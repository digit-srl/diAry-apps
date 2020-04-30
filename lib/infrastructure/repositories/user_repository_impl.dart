import 'package:diary/infrastructure/data/user_local_data_sources.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:diary/utils/logger.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSources userLocalDataSources;
//  final UserRemoteDataSources userLocalRemoteSources;

  UserRepositoryImpl(this.userLocalDataSources);

  @override
  bool isThereHomeGeofence() {
    logger.i('[UserRepositoryImpl] isThereHomeGeofence()');
    return userLocalDataSources.isThereHomeGeofence();
  }

  @override
  Future<void> setHomeGeofenceIdentifier(String identifier) async {
    logger.i('[UserRepositoryImpl] setHomeGeofenceIdentifier()');
    await userLocalDataSources.setHomeGeofenceIdentifier(identifier);
  }

  @override
  Future<void> removeHomeGeofence() async {
    logger.i('[UserRepositoryImpl] removeHomeGeofence()');
    await userLocalDataSources.removeHomeGeofence();
  }

  @override
  String getHomeGeofenceIdentifier() {
    logger.i('[UserRepositoryImpl] getHomeGeofenceIdentifier()');
    return userLocalDataSources.getHomeGeofenceIdentifier();
  }

  @override
  Future<String> getUserUuid() async {
    final uuid = userLocalDataSources.getUserUuid();
    if (uuid == null) {
      final newUuid = Uuid().v1();
      await userLocalDataSources.saveUuid(newUuid);
      return newUuid;
    }
    return uuid;
  }

  @override
  int getDailyAnnotationCount(DateTime date) {
    return userLocalDataSources.getAnnotationCount(date);
  }

  @override
  DateTime getLastCallToActionDate() {
    final date = userLocalDataSources.getLastCallToActionDate();
    if (date == null) return null;
    return date.isUtc ? date : date.toUtc();
  }

  @override
  Future<void> saveCallToActionDate(DateTime dateTime) async {
    await userLocalDataSources.saveCallToActionDate(dateTime);
  }
}
