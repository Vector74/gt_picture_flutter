import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gt_picture/globals/global_vars.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import for MediaType
import '../models/main_response.dart';
import '../models/user_response.dart';
import '../models/gtfolders.dart';
import '../models/gtitem.dart'; // Import the GTItem model

class CoreUtil {
  Future<String> _loadBaseUrl() async {
    final jsonString = await rootBundle.loadString('assets/appsettings.json');
    final jsonMap = jsonDecode(jsonString);
    return jsonMap['baseurl'];
  }

  Future<http.Response> callApi(String cmd, Map<String, dynamic> data) async {
    final baseUrl = await _loadBaseUrl();
    final url = Uri.parse(baseUrl);
    final body = {'cmd': cmd, ...data};
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    return response;
  }

  Future<http.StreamedResponse> callApiWithMultipart(
    String cmd,
    Map<String, String> data,
    List<http.MultipartFile> files,
  ) async {
    final baseUrl = await _loadBaseUrl();
    final url = Uri.parse(baseUrl);

    final request =
        http.MultipartRequest('POST', url)
          ..fields['cmd'] = cmd
          ..fields.addAll(data)
          ..files.addAll(files);

    final response = await request.send();
    return response;
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Bejelentkezés metódus
  Future<MainResponse> login(String id) async {
    final response = await callApi('auth', {'id': id});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> data = {};

      if (jsonResponse['status'] == 0) {
        data = UserResponse.fromJson(jsonResponse['data']).toJson();
      }

      return MainResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: data,
        command: jsonResponse['command'],
      );
    } else {
      throw Exception('Bejelentkezés sikertelen: ${response.statusCode}');
    }
  }

  // Mappák lekérése
  Future<MainResponse> getFolders() async {
    final response = await callApi('folders', {});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<GTFolders> folders = [];

      if (jsonResponse['status'] == 0) {
        // Folders lista feldolgozása
        folders =
            (jsonResponse['data']['folders'] as List)
                .map((folderJson) => GTFolders.fromJson(folderJson))
                .toList();
      }

      // Folders lista becsomagolása egy map-be
      return MainResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: {'folders': folders},
        command: jsonResponse['command'],
      );
    } else {
      throw Exception('Mappák lekérése sikertelen: ${response.statusCode}');
    }
  }

  // Új metódus az elemek lekéréséhez
  Future<MainResponse> getItems() async {
    final response = await callApi('items', {});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<GTItem> items = [];

      if (jsonResponse['status'] == 0) {
        // Items lista feldolgozása
        items =
            (jsonResponse['data']['items'] as List)
                .map((itemJson) => GTItem.fromJson(itemJson))
                .toList();
      }

      // Items lista becsomagolása egy map-be
      return MainResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: {'items': items},
        command: jsonResponse['command'],
      );
    } else {
      throw Exception('Elemek lekérése sikertelen: ${response.statusCode}');
    }
  }

  // Új metódus a base64 kódolt képek küldéséhez
  Future<List<MainResponse>> sendImages(List<String> capturedImages) async {
    List<MainResponse> responses = []; // Lista a válaszok tárolására
    final List<http.MultipartFile> multipartFiles = [];

    for (String image in capturedImages) {
      // Fájlnév generálása a megadott formátum szerint
      final now = DateTime.now();
      final formattedDate =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}"
          "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final filename =
          "image_${GlobalVars.selectedItem?.id.toString() ?? '0'}_${GlobalVars.selectedFolder?.id.toString() ?? '0'}_$formattedDate.jpg";
      final multipartFile = await http.MultipartFile.fromPath(
        'files', // A paraméter neve, amit a szerver vár
        image,
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      );
      multipartFiles.add(multipartFile);
    }
    // MultipartData változó létrehozása további mezőkkel
    final multipartData = {
      'id': GlobalVars.selectedItem?.id.toString() ?? '0',
      'folderid': GlobalVars.selectedFolder?.id.toString() ?? '0',
      'userid': GlobalVars.currentUser?.id.toString() ?? '0',
    };

    // API hívás végrehajtása multipart formátumban
    final response = await callApiWithMultipart(
      'imgupload',
      multipartData,
      multipartFiles,
    );

    if (response.statusCode == 200) {
      // JSON válasz dekódolása
      var a = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(a);
      // Válasz hozzáadása a listához
      responses.add(
        MainResponse(
          status: jsonResponse['status'],
          message: jsonResponse['message'],
          data: {}, // Nincs szükség adatfeldolgozásra
          command: jsonResponse['command'],
        ),
      );
    } else {
      // Kivétel dobása, ha a kép küldése sikertelen
      throw Exception('Kép küldése sikertelen: ${response.statusCode}');
    }

    return responses; // Visszatér a válaszok listájával
  }
}
