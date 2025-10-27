import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Importáljuk a kamera csomagot
import 'package:gt_picture/models/main_response.dart';
import 'dart:io'; // Importáljuk a dart:io csomagot a fájlkezeléshez
import '../globals/global_vars.dart'; // Importáljuk a GlobalVars-t
import '../components/main_app_bar.dart'; // Importáljuk a MainAppBar-t
import '../utils/core_util.dart'; // Importáljuk a CoreUtil-t

class GTImageScreen extends StatefulWidget {
  const GTImageScreen({super.key});

   @override
  State<GTImageScreen> createState() => _GTImageScreenState();
}

class _GTImageScreenState extends State<GTImageScreen> {
  CameraController? _cameraController;
  List<String> capturedImages =
      []; // Lista az elkészült képek útvonalainak tárolására
  final CoreUtil coreUtil = CoreUtil(); // CoreUtil példányosítása

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Az eszközön elérhető kamerák listájának lekérése
    final cameras = await availableCameras();
    // Az első kamera kiválasztása (általában a hátsó kamera)
    final firstCamera = cameras.first;

    // A kamera vezérlő inicializálása
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);

    // A vezérlő inicializálása és a felület frissítése, amikor kész
    await _cameraController?.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          capturedImages.add(image.path);
        });
      } catch (e) {
        coreUtil.showSnackBar(
          context,
          'Hiba történt a kép készítésekor: $e',
          Colors.red,
        );
      }
    }
  }

  void _sendImage() async {

    try {
      // A CoreUtil.sendImages hívása a base64 kódolt képek listájával
      List<MainResponse> responses = await coreUtil.sendImages(capturedImages);

      // Ellenőrizzük, hogy az összes válasz sikeres-e
      if (responses.every((response) => response.status == 0)) {
        coreUtil.showSnackBar(
          context,
          'Sikeres képbeküldés',
          Colors.green,
        ); // Sikeres üzenet megjelenítése
        Navigator.of(context).pop(); // Visszalépés az előző képernyőre
      } else {
        coreUtil.showSnackBar(
          context,
          'Hiba történt a képek küldésekor',
          Colors.red,
        );
      }
    } catch (e) {
      coreUtil.showSnackBar(context, 'Kép küldése sikertelen: $e', Colors.red);
    }
  }

  void _deleteImage(int index) {
    setState(() {
      capturedImages.removeAt(index);
    });
  }

  @override
  void dispose() {
    // A kamera vezérlő eldobása, amikor a widget eldobásra kerül
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title:
            GlobalVars.getSelectedFolder()?.name ??
            'Képek', // A címke a kiválasztott mappa neve
      ),
      body: Column(
        children: [
          // Felső 2/3 rész a kamera előnézethez
          Expanded(
            flex: 2,
            child:
                _cameraController == null ||
                        !_cameraController!.value.isInitialized
                    ? Center(child: CircularProgressIndicator())
                    : CameraPreview(_cameraController!),
          ),
          // Gombok a kamera előnézet alatt
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _captureImage,
                icon: Icon(Icons.camera_alt),
                label: Text('Kép készítése'),
              ),
              SizedBox(width: 10), // Kis távolság az ikon és a gomb között
              if (capturedImages.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: _sendImage,
                  icon: Icon(Icons.send),
                  label: Text('Küldés'),
                ),
            ],
          ),
          // Alsó 1/3 rész az elkészült képek horizontális listájához
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: capturedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(capturedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteImage(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
