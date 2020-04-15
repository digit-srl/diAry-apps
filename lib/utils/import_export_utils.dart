import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/entities/location.dart';
import 'location_utils.dart';

class ImportExportUtils {
  static Future<List<File>> saveFilesOnLocalStorage(
      List<Location> locations, DateTime currentDate) async {
    List<Map<String, dynamic>> result = [];
//  final locations = await bg.BackgroundGeolocation.locations;
    for (Location loc in locations) {
      result.add(loc.toJson());
    }
    var csv = mapListToCsv(result);
    var jsonEncoded = json.encode(result);

    final csvFile = await writeCsv(csv, currentDate);
    final jsonFile = await writeJson(jsonEncoded, currentDate);
    return [csvFile, jsonFile];
  }

  static Future<String> _localPath(DateTime currentDate) async {
    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    return directory.path;
  }

  static Future<File> _localFile(DateTime currentDate) async {
    final path = await _localPath(currentDate);
    return File(
        '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.csv');
  }

  static Future<File> writeCsv(String data, DateTime currentDate) async {
    final file = await _localFile(currentDate);
    print(file.path);

    // Write the file.
    return await file.writeAsString('$data');
  }

  static Future<File> writeJson(String data, DateTime currentDate) async {
    final path = await _localPath(currentDate);
    final file = File(
        '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.json');
    print(file.path);
    return file.writeAsString('$data');
  }

  /// Convert a map list to csv
  static String mapListToCsv(List<Map<String, dynamic>> mapList,
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

  static Future<AggregationData> importAndProcessJSON() async {
    final File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['json']);
    final String data = await file.readAsString();
    final map = json.decode(data);
    final locations = List<Map<String, dynamic>>.from(map)
        .map((element) => Location.fromJson(element))
        .toList();
//    final list = List<Map<String, dynamic>>.from(map)
//        .map((element) => Loc.fromJson(element))
//        .toList();
    print(locations.length);

    locations.forEach((loc) {
      final speed = loc?.coords?.speed ?? 0.0;
      if (speed < 0.5) {
        loc.activity.type = 'still';
      }
    });
    return LocationUtils.aggregateLocationsInSlices3(locations);
  }

  static Future<List<Location>> importJSON() async {
    final File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['json']);
    final String data = await file.readAsString();
    final map = json.decode(data);
    final locations = List<Map<String, dynamic>>.from(map)
        .map((element) => Location.fromJson(element))
        .toList();
    print(locations.length);

    locations.forEach((loc) {
      final speed = loc?.coords?.speed ?? 0.0;
      if (speed < 0.5) {
        loc.activity.type = 'still';
      }
    });
    return locations;
  }
}
