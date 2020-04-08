import 'package:diary/infrastructure/data/user_local_data_sources.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSources userLocalDataSources;
//  final UserRemoteDataSources userLocalRemoteSources;

  UserRepositoryImpl(this.userLocalDataSources);

  @override
  bool isThereHomeGeofence() {
    print('[UserRepositoryImpl] isThereHomeGeofence()');
    return userLocalDataSources.isThereHomeGeofence();
  }

  @override
  Future<void> setHomeGeofenceIdentifier(String identifier) async {
    print('[UserRepositoryImpl] setHomeGeofenceIdentifier()');
    await userLocalDataSources.setHomeGeofenceIdentifier(identifier);
  }

  @override
  Future<void> removeHomeGeofence() async {
    print('[UserRepositoryImpl] removeHomeGeofence()');
    await userLocalDataSources.removeHomeGeofence();
  }

  @override
  String getHomeGeofenceIdentifier() {
    print('[UserRepositoryImpl] getHomeGeofenceIdentifier()');
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
}
