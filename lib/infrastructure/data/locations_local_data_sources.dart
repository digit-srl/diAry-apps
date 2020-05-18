import 'dart:convert';

import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:hive/hive.dart';

import '../../database.dart' as db;

abstract class LocationsLocalDataSources {
  Future<List<Location>> getAllLocations();
  Future<List<Location>> getLocationsBetween(DateTime start, DateTime end);
  Future saveNewCallToActionResult(Call call);
  List<Call> getAllCalls();
  Future deleteCall(Call call);
}

class LocationsLocalDataSourcesImpl implements LocationsLocalDataSources {
  Box<Call> box;

  LocationsLocalDataSourcesImpl() {
    box = Hive.box('calls');
  }

  @override
  Future<List<Location>> getAllLocations() async {
    final List<Map<String, dynamic>> list =
        await db.DiAryDatabase.get().getAllLocations();
    final locations = list
        .map(
          (dbLoc) => Location.fromJson(
            json.decode(
              String.fromCharCodes(dbLoc['data']),
            ),
          ),
        )
        .toList();
    return locations;
  }

  @override
  Future<List<Location>> getLocationsBetween(
      DateTime start, DateTime end) async {
    final List<Map<String, dynamic>> list = await db.DiAryDatabase.get()
        .getLocationsBetween(start.toUtc().toIso8601String().substring(0, 10),
            end.toUtc().toIso8601String().substring(0, 10));
    final locations = list
        .map((dbLoc) =>
            Location.fromJson(json.decode(String.fromCharCodes(dbLoc['data']))))
        .toList();
    return locations;
  }

  @override
  Future saveNewCallToActionResult(Call call) async {
    await box.put(call.id, call);
  }

  @override
  List<Call> getAllCalls() {
    return box.values.toList();
  }

  @override
  Future deleteCall(Call call) async {
    await box.delete(call.id);
  }
}
