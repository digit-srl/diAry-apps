import 'dart:async';
import 'dart:convert';

import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../database.dart' as db;

abstract class LocationsLocalDataSources {
  Future<List<Location>> getAllLocations(String a);
  Future<List<Location>> getLocationsBetween(DateTime start, DateTime end);
  Future saveNewCallToActionResult(Call call);
  Future updateCall(Call call);
  List<Call> getAllCalls();
  Future deleteCall(Call call);
}

List<Location> buildLocations(List<Map<String, dynamic>> list) {
  final locations = list
      .map<Location>(
        (dbLoc) => Location.fromJson(
          json.decode(
            String.fromCharCodes(dbLoc['data']),
          ),
        ),
      )
      .toList();
  return locations;
}

class LocationsLocalDataSourcesImpl implements LocationsLocalDataSources {
  Box<Call> box;

  LocationsLocalDataSourcesImpl() {
    box = Hive.box('calls');
  }

  @override
  Future<List<Location>> getAllLocations(String a) async {
    final start = DateTime.now();
    final List<Map<String, dynamic>> list =
        await db.DiAryDatabase.get().getAllLocations();
    final partialTime = DateTime.now();
    print(
        'locations readed from db : ${partialTime.difference(start).inMilliseconds}');

    final locations = await compute<List<Map<String, dynamic>>, List<Location>>(
        buildLocations, list);
    final endTime = DateTime.now();
    print(
        'locations builded: ${endTime.difference(partialTime).inMilliseconds}');
    return locations;
  }

  @override
  Future<List<Location>> getLocationsBetween(
      DateTime start, DateTime end) async {
    final fromString = start.toIso8601String();
    final toString = end.toIso8601String();
    final List<Map<String, dynamic>> list =
        await db.DiAryDatabase.get().getLocationsBetween(fromString, toString);
    final locations = await compute<List<Map<String, dynamic>>, List<Location>>(
        buildLocations, list);
    return locations;
  }

  @override
  Future saveNewCallToActionResult(Call call) async {
    call.insertedDate = DateTime.now();
    await box.put(call.id, call);
  }

  @override
  Future updateCall(Call call) async {
    await box.put(call.id, call);
  }

  @override
  List<Call> getAllCalls() {
    final list = box.values.toList();
    if (list.isNotEmpty) {
      list.sort((a, b) => (b.insertedDate ?? DateTime.now())
          .compareTo(a.insertedDate ?? DateTime.now()));
    }
    return list;
  }

  @override
  Future deleteCall(Call call) async {
    await box.delete(call.id);
  }
}
