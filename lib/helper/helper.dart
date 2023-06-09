import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Party.dart';

File filePath = File("");

Map<String, dynamic> file_data = {};

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await _localPath;
  print(path);
  return File('$path/data.json');
}

Future initFile() async {
  String json = await rootBundle.loadString("assets/data.json");
  Map<String, dynamic> jsonType = jsonDecode(json);

  String jsonEncoded = jsonEncode(jsonType);
  final file = await localFile;
  try {
    file.writeAsString(jsonEncoded);
  } catch (e) {
    print("Something went wrong $e");
  }
}




Future writeToFile(dynamic file) async {
  String jsonString = jsonEncode(file);
  try {
    filePath.writeAsStringSync(jsonString);
  } catch (e) {
    print("Something went wrong $e");
  }
}

class Helper {
  Future writeToFile(dynamic file) async {
    String jsonString = jsonEncode(file);
    try {
      filePath.writeAsStringSync(jsonString);
    } catch (e) {
      print("Something went wrong $e");
    }
  }





}