import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:path_provider/path_provider.dart';

import '../domain/entities/loc.dart';

exportCsv(List<bg.Location> locations, DateTime currentDate) async {
  List<Map<String, dynamic>> result = [];
//  final locations = await bg.BackgroundGeolocation.locations;
  for (bg.Location loc in locations) {
    result.add(Loc.fromJson(Map<String, dynamic>.from(loc.map)).toJson());
  }
  var csv = mapListToCsv(result);
  var jjj = json.encode(result);
  writeJson(jjj, currentDate);
  return await writeCsv(csv, currentDate);
}

Future<String> _localPath(DateTime currentDate) async {
  final directory = Platform.isIOS
      ? await getApplicationDocumentsDirectory()
      : await getExternalStorageDirectory();

  return directory.path;
}

Future<File> _localFile(DateTime currentDate) async {
  final path = await _localPath(currentDate);
  return File(
      '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.csv');
}

Future<File> writeCsv(String data, DateTime currentDate) async {
  final file = await _localFile(currentDate);
  print(file.path);

  // Write the file.
  return await file.writeAsString('$data');
}

Future<File> writeJson(String data, DateTime currentDate) async {
  final path = await _localPath(currentDate);
  final file = File(
      '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.json');
  print(file.path);
  return file.writeAsString('$data');
}

/// Convert a map list to csv
String mapListToCsv(List<Map<String, dynamic>> mapList,
    {ListToCsvConverter converter}) {
  if (mapList == null) {
    return null;
  }
  converter ??= const ListToCsvConverter();
  var data = <List>[];
  var keys = <String>[];
  var keyIndexMap = <String, int>{};

  // Add the key and fix previous records
  int _addKey(String key) {
    var index = keys.length;
    keyIndexMap[key] = index;
    keys.add(key);
    for (var dataRow in data) {
      dataRow.add(null);
    }
    return index;
  }

  for (var map in mapList) {
    // This list might grow if a new key is found
    var dataRow = List(keyIndexMap.length);
    // Fix missing key
    map.forEach((key, value) {
      var keyIndex = keyIndexMap[key];
      if (keyIndex == null) {
        // New key is found
        // Add it and fix previous data
        keyIndex = _addKey(key);
        // grow our list
        dataRow = List.from(dataRow, growable: true)..add(value);
      } else {
        dataRow[keyIndex] = value;
      }
    });
    data.add(dataRow);
    print(map);
  }
  return converter.convert(<List>[]
    ..add(keys)
    ..addAll(data));
}
