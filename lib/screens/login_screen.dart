import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../components/main_app_bar.dart';
import '../utils/core_util.dart';
import '../models/main_response.dart';
import '../models/user_response.dart';
import '../globals/global_vars.dart';
import 'gt_items_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CoreUtil _coreUtil = CoreUtil();

  @override
  void initState() {
    super.initState();
    // NFC olvasás indítása az alkalmazás betöltésekor.
    _startNFC();
  }

  // NFC olvasás végrehajtása
  Future<void> _startNFC() async {
    try {
      // NFC címke beolvasása
      var tag = await FlutterNfcKit.poll(androidCheckNDEF: true);

      // Bejelentkezés az NFC címke azonosítójával
      if (tag.ndefAvailable!) {
        var ndefId = '';
        // NFC rekordok beolvasása és az azonosító összegyűjtése
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          ndefId = record.toString();
        }
        // Az azonosító első "=" karakterig történő kivágása
        var processedNdefId = ndefId.split('=').last;
        // API hívás az NFC adatokkal
        await _callApiWithNfcData(processedNdefId);
      }
    } catch (e) {
      // Hiba esetén SnackBar megjelenítése piros színnel
      _coreUtil.showSnackBar(
        context,
        'Hiba történt az NFC olvasás során: $e',
        Colors.red,
      );
    }
  }

  // Bejelentkezés végrehajtása az NFC adatokkal
  // Bejelentkezés végrehajtása az NFC adatokkal
Future<void> _callApiWithNfcData(String tagId) async {
  try {
    // Bejelentkezés a CoreUtil osztály login metódusával
    final MainResponse response = await _coreUtil.login(tagId);
    if (response.status == 0) {
      // Sikeres bejelentkezés esetén a UserResponse beállítása a GlobalVars-ban
      GlobalVars.setUser(UserResponse.fromJson(response.data));
      // GTItemsScreen betöltése
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GTItemsScreen(),
        ),
      );
    } else {
      // Hibás bejelentkezés esetén a hibaüzenet megjelenítése
      _coreUtil.showSnackBar(context, response.message, Colors.red);
      // Újraindítja az NFC olvasást setState használatával
      setState(() {
        _startNFC();
      });
    }
  } catch (e) {
    // Hiba esetén SnackBar megjelenítése piros színnel
    _coreUtil.showSnackBar(
      context,
      'Bejelentkezés során hiba történt: $e',
      Colors.red,
    );
    // Újraindítja az NFC olvasást setState használatával
    setState(() {
      _startNFC();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Bejelentkezés'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Kép megjelenítése
            Image.asset('assets/gt.png'),
            SizedBox(height: 16.0),
            // Betöltési indikátor
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}