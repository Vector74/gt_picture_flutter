import 'package:flutter/material.dart';
import '../models/gtfolders.dart';
import '../utils/core_util.dart';
import '../models/main_response.dart';
import '../globals/global_vars.dart'; // Import GlobalVars
import '../components/main_app_bar.dart'; // Import MainAppBar
import 'gt_image_screen.dart'; // Import GTImageScreen

class GTFoldersScreen extends StatefulWidget {
  const GTFoldersScreen({super.key});

   @override
  State<GTFoldersScreen> createState() => _GTFoldersScreenState();

}

class _GTFoldersScreenState extends State<GTFoldersScreen> {
  final CoreUtil _coreUtil = CoreUtil();
  List<GTFolders> folders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFolders();
  }

  Future<void> _fetchFolders() async {
    try {
      // Mappák lekérése az API-ból
      MainResponse response = await _coreUtil.getFolders();
      if (response.status == 0) {
        setState(() {
          folders = response.data['folders'];
          isLoading = false;
        });
      } else {
        _coreUtil.showSnackBar(context, response.message, Colors.red);
      }
    } catch (e) {
      _coreUtil.showSnackBar(
        context,
        'Hiba történt a mappák lekérése során: $e',
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Műveletek'), // A címke "Műveletek"-re változtatása
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                final folder = folders[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse('0xFF${folder.color}')), // Gomb alapszíne
                    ),
                    onPressed: () {
                      // Kiválasztott mappa elmentése a GlobalVars-ba
                      GlobalVars.setSelectedFolder(folder);
                      // GTImageScreen betöltése
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GTImageScreen()),
                      );
                    },
                    child: Text(folder.name), // Gomb címe
                  ),
                );
              },
            ),
    );
  }
}