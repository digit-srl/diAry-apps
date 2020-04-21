import 'package:dartz/dartz.dart';
import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/infrastructure/data/locations_local_data_sources.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> getAllLocations();
  Future<Either<Failure, List<Location>>> getLocationsBetween(
      DateTime start, DateTime end);
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
}
