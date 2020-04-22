import 'dart:convert';

import 'package:diary/domain/entities/location.dart';

import '../../database.dart' as db;

abstract class LocationsLocalDataSources {
  Future<List<Location>> getAllLocations();
  Future<List<Location>> getLocationsBetween(DateTime start, DateTime end);
}

class LocationsLocalDataSourcesImpl implements LocationsLocalDataSources {
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
}

/*onPressed: () async {
                  final result = await ctx
                      .read<LocationRepositoryImpl>()
                      .getAllLocations();
                  result.fold((f) => print(f), (locs) => print(locs.length));
//                  print(locs.length);
                },*/
