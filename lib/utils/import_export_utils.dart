import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../domain/entities/location.dart';
import 'alerts.dart';
import 'logger.dart';
import 'package:provider/provider.dart';

class ImportExportUtils {
  static Tuple2<String, String> _getJsonAndCsv(List<Location> locations) {
    List<Map<String, dynamic>> result = [];
    for (Location loc in locations) {
      result.add(loc.toJson());
    }

    var csv = _mapListToCsv(result);
    var jsonEncoded = json.encode(result);
    return Tuple2(csv, jsonEncoded);
  }

  static Future<List<File>> _saveFilesOnLocalStorage(
      Tuple3<List<Location>, DateTime, String> tuple) async {
//    List<Map<String, dynamic>> result = [];
//  final locations = await bg.BackgroundGeolocation.locations;
//    for (Location loc in tuple.value1) {
//      result.add(loc.toJson());
//    }
//    var csv = await compute(_mapListToCsv, result);
//    var jsonEncoded = await compute(json.encode, result);

    List<Map<String, dynamic>> result = [];
    for (Location loc in tuple.value1) {
      result.add(loc.toJson());
    }

    var csv = _mapListToCsv(result);
    var jsonEncoded = json.encode(result);

    final csvFile = await writeCsv(csv, tuple.value2, tuple.value3);
    final jsonFile = await writeJson(jsonEncoded, tuple.value2, tuple.value3);
    return [csvFile, jsonFile];
  }

  static Future<String> _localPath() async {
    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    return directory.path;
  }

/*  static Future<File> _localFile(DateTime currentDate) async {
    final path = await _localPath(currentDate);
    return File(
        '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.csv');
  }*/

  static Future<File> writeCsv(
      String data, DateTime currentDate, String path) async {
    final file = File(
        '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.csv');
    logger.i(file.path);
    return file.writeAsString('$data');
  }

  static Future<File> writeJson(
      String data, DateTime currentDate, String path) async {
    final file = File(
        '$path/export_${currentDate.day}_${currentDate.month}_${currentDate.year}_${Random().nextInt(10000)}.json');
    logger.i(file.path);
    return file.writeAsString('$data');
  }

  /// Convert a map list to csv
  static String _mapListToCsv(List<Map<String, dynamic>> mapList,
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
      logger.i(map);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }

/*  static Future<List<Location>> importJSON() async {
    final File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['json']);
    final String data = await file.readAsString();
    final map = json.decode(data);
    final locations = List<Map<String, dynamic>>.from(map)
        .map((element) => Location.fromJson(element))
        .toList();
    logger.i(locations.length);
    return locations;
  }*/

  static exportAllData(BuildContext context) async {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    logger.i(permissionStatus);
    if (permissionStatus == PermissionStatus.neverAskAgain) {
      Alerts.showAlertWithPosNegActions(
          context,
          "Attenzione",
          "In percedenza hai disabilitato il permesso di archiviazione. E' "
              "necessario abilitarlo manualmente dalle impostazioni di sistema.",
          "Vai a Impostazioni", () {
        PermissionHandler().openAppSettings();
      });
      return;
    } else if (permissionStatus != PermissionStatus.granted) {
      final permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return;
      }
    }

    Alerts.showLoading(context);

    final List<Location> locations =
        (await context.read<LocationRepositoryImpl>().getAllLocations())
            .getOrElse(() => []);
    final path = await _localPath();
//    final files = await compute(ImportExportUtils._saveFilesOnLocalStorage,
//        Tuple2(locations, DateTime.now()));
//    final tuple2 =
//        await compute<List<Location>, Tuple2>(_getJsonAndCsv, locations);
    final List<File> files = await compute(
        ImportExportUtils._saveFilesOnLocalStorage,
        Tuple3(locations, DateTime.now(), path));
    if (files == null || files.isEmpty) return;
    final csvFile = files[0];
    final jsonFile = files[1];
    final csvPath = csvFile.path;
    final jsonPath = jsonFile.path;

    Navigator.of(context).pop();
    Alerts.showAlertWithTwoActions(
        context,
        "Esporta tutti i dati",
        "Seleziona il formato per l'esportazione dei dati.",
        "CSV",
        () {
          Share.file('Il mio file CSV', csvPath.split('/').last,
              csvFile.readAsBytesSync(), 'application/*');
        },
        "JSON",
        () {
          Share.file('Il mio file JSON', jsonPath.split('/').last,
              jsonFile.readAsBytesSync(), 'application/*');
        });
  }

  static exportSingleDay(BuildContext context) async {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    logger.i(permissionStatus);
    if (permissionStatus == PermissionStatus.neverAskAgain) {
      Alerts.showAlertWithPosNegActions(
          context,
          "Attenzione",
          "In percedenza hai disabilitato il permesso di archiviazione. E' "
              "necessario abilitarlo manualmente dalle impostazioni di sistema.",
          "Vai a Impostazioni", () {
        PermissionHandler().openAppSettings();
      });
      return;
    } else if (permissionStatus != PermissionStatus.granted) {
      final permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return;
      }
    }

    final currentDate =
        Provider.of<DateState>(context, listen: false).selectedDate;

    final List<Location> locations =
        Provider.of<LocationNotifier>(context, listen: false)
            .getCurrentDayLocations;
    final path = await _localPath();
//    final tuple2 =
//        await compute<List<Location>, Tuple2>(_getJsonAndCsv, locations);
    final List<File> files = await compute(
        ImportExportUtils._saveFilesOnLocalStorage,
        Tuple3(locations, currentDate, path));
    if (files == null || files.isEmpty) return;
    final csvFile = files[0];
    final jsonFile = files[1];
    final csvPath = csvFile.path;
    final jsonPath = jsonFile.path;

    Alerts.showAlertWithTwoActions(
        context,
        "Esporta i dati relativi al giorno visualizzato",
        "Seleziona il formato per l'esportazione dei dati.",
        "CSV",
        () {
          Share.file('Il mio file CSV', csvPath.split('/').last,
              csvFile.readAsBytesSync(), 'application/*');
        },
        "JSON",
        () {
          Share.file('Il mio file JSON', jsonPath.split('/').last,
              jsonFile.readAsBytesSync(), 'application/*');
        });
  }
}
