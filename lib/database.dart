import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';

class DiAryDatabase {
  static final DiAryDatabase _appDatabase = new DiAryDatabase._internal();
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
        join(dbFolder.parent.path, 'databases/transistor_location_manager'));
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
      print('[DiAryDatabase] [getAllLocations] $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLocationsBetween(
      String start, String end) async {
    try {
      final _db = await getDb();
      final query =
          'SELECT * FROM locations WHERE timestamp BETWEEN "$start" AND "$end";';
      print('[DiAryDatabase] [getLocationsBetween] query: $query');
      var result = await _db.rawQuery(query);
      return result;
    } catch (e) {
      print('[DiAryDatabase] [getLocationsBetween] $e');
      return [];
    }
  }
}
