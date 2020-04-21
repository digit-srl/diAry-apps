import 'dart:convert';

import 'package:diary/domain/entities/location.dart';

import '../../database.dart' as db;

abstract class LocationsLocalDataSources {
  Future<List<Location>> getAllLocations();
  Future<List<Location>> getLocationsBetween(DateTime start, DateTime end);
}

class LocationsLocalDataSourcesImpl implements LocationsLocalDataSources {
  db.MoorDb moorDb;
  LocationsLocalDataSourcesImpl(this.moorDb);

  @override
  Future<List<Location>> getAllLocations() async {
    final List<db.Location> list = await moorDb.getAllLocations().get();
    final locations = list
        .map((dbLoc) =>
            Location.fromJson(json.decode(String.fromCharCodes(dbLoc.data))))
        .toList();
    return locations;
  }

  @override
  Future<List<Location>> getLocationsBetween(
      DateTime start, DateTime end) async {
    final List<db.Location> list = await moorDb
        .getLocationsBetween(start.toIso8601String(), end.toIso8601String())
        .get();
    final locations = list
        .map((dbLoc) =>
            Location.fromJson(json.decode(String.fromCharCodes(dbLoc.data))))
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
