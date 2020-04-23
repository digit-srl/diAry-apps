import 'package:dartz/dartz.dart';
import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/infrastructure/data/locations_local_data_sources.dart';
import 'package:diary/utils/extensions.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:diary/utils/logger.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> getAllLocations();
  Future<Either<Failure, List<Location>>> getLocationsBetween(
      DateTime start, DateTime end);
  Future<Map<DateTime, List<Location>>> readAndFilterLocationsPerDay();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationsLocalDataSources locationsLocalDataSources;

  LocationRepositoryImpl(this.locationsLocalDataSources);

  @override
  Future<Either<Failure, List<Location>>> getAllLocations() async {
    try {
      final locations = await locationsLocalDataSources.getAllLocations();
      return right(locations);
    } catch (e) {
      logger.e(e);
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getLocationsBetween(
      DateTime start, DateTime end) async {
    try {
      final locations =
          await locationsLocalDataSources.getLocationsBetween(start, end);
      return right(locations);
    } catch (e) {
      logger.e(e);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Map<DateTime, List<Location>>> readAndFilterLocationsPerDay() async {
    Map<DateTime, List<Location>> locationsPerDay = {};
    final locations = await locationsLocalDataSources.getAllLocations();
    logger.i('[LocationUtils] total records: ${locations.length}');
    final DateTime today = DateTime.now().withoutMinAndSec();
    if (locations.isEmpty) {
      return {today: []};
    }
    for (var loc in locations) {
      try {
        final date = loc.dateTime.withoutMinAndSec();
        if (!locationsPerDay.containsKey(date)) {
          locationsPerDay[date] = [];
        }
        locationsPerDay[date].add(loc);
      } catch (ex) {
        logger.e('[ERROR] _readLocations $ex');
      }
    }
    logger.i('Locations from DB: ${locations.length}');
    return locationsPerDay;
  }

  Future<Map<DateTime, Set<String>>> callToAction() async {
    final map = <DateTime, Set<String>>{};

    final result = await getAllLocations();
    final locations = result.getOrElse(() => []);
    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];
      final date = loc.dateTime.withoutMinAndSec();
      if (!map.containsKey(date)) {
        map[date] = {};
      }
      final geohash = LocationUtils.getGeohash(
          loc.coords.latitude, loc.coords.longitude,
          precision: 4);
      map[date].add(geohash);
    }

    return map;
  }

  getLocationsPerDate() async {
    final locationsPerDate = await readAndFilterLocationsPerDay();
    final days = LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);
    return days;
  }
}
