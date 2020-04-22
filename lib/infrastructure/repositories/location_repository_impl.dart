import 'package:dartz/dartz.dart';
import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/infrastructure/data/locations_local_data_sources.dart';
import 'package:diary/utils/extensions.dart';
import 'package:diary/utils/location_utils.dart';

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
      print(e);
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
      print(e);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Map<DateTime, List<Location>>> readAndFilterLocationsPerDay() async {
    Map<DateTime, List<Location>> locationsPerDay = {};
    final locations = await locationsLocalDataSources.getAllLocations();
    print('[LocationUtils] total records: ${locations.length}');
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
        print('[ERROR] _readLocations $ex');
      }
    }
    print('Locations from DB: ${locations.length}');
    return locationsPerDay;
  }

  getLocationsPerDate() async {
    final locationsPerDate = await readAndFilterLocationsPerDay();
    final days = LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);
    return days;
  }
}
