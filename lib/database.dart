import 'dart:io';
import 'package:diary/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';

class DiAryDatabase {
  static final DiAryDatabase _appDatabase = DiAryDatabase._internal();
  final _lock = new Lock();

  DiAryDatabase._internal();

  Database _database;

  static DiAryDatabase get() {
    return _appDatabase;
  }

  Future<Database> getDb() async {
    if (_database == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_database == null) {
          await _init();
        }
      });
    }
    return _database;
  }

  Future<String> getPath() async {
    String path;

    if (Platform.isIOS) {
      final dbFolder = await getApplicationSupportDirectory();
      path =
          join(dbFolder.path, 'TSLocationManager/ts_location_manager.sqlite');
    } else if (Platform.isAndroid) {
      final dbFolder = await getApplicationDocumentsDirectory();
      path =
          join(dbFolder.parent.path, 'databases/transistor_location_manager');
    } else {
      throw Exception('The platform is not supported');
    }
    logger.i(path);
    final file = File(path);
    return file.path;
  }

  _init() async {
    final path = await getPath();
    _database = await openReadOnlyDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    try {
      final _db = await getDb();
      var result = await _db.rawQuery('SELECT * FROM locations;');
      return result;
    } catch (e) {
      logger.e('[DiAryDatabase] [getAllLocations] $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLocationsBetween(
      String start, String end) async {
    try {
      final _db = await getDb();
      final query =
          'SELECT * FROM locations WHERE timestamp BETWEEN "$start" AND "$end";';
      logger.i('[DiAryDatabase] [getLocationsBetween] query: $query');
      var result = await _db.rawQuery(query);
      return result;
    } catch (e) {
      logger.e('[DiAryDatabase] [getLocationsBetween] $e');
      return [];
    }
  }
}
