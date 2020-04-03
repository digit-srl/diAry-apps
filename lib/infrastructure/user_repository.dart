import 'package:hive/hive.dart';

abstract class UserRepository {
  bool isThereHomeGeofence();

  Future<void> setHomeGeofenceIdentifier(String identifier);

  String getHomeGeofenceIdentifier();

  Future<void> removeHomeGeofence();
}

const String homeGeofenceKey = 'homeGeofence';

class UserRepositoryImpl extends UserRepository {
  final Box userBox;

  UserRepositoryImpl(this.userBox);

  @override
  bool isThereHomeGeofence() {
    print('[UserRepositoryImpl] isThereHomeGeofence()');
    final result = userBox.containsKey(homeGeofenceKey);
    print(result);
    return result;
  }

  @override
  Future<void> setHomeGeofenceIdentifier(String identifier) async {
    print('[UserRepositoryImpl] setHomeGeofenceIdentifier()');
    await userBox.put(homeGeofenceKey, identifier);
  }

  @override
  Future<void> removeHomeGeofence() async {
    print('[UserRepositoryImpl] removeHomeGeofence()');
    await userBox.delete(homeGeofenceKey);
  }

  @override
  String getHomeGeofenceIdentifier() {
    print('[UserRepositoryImpl] getHomeGeofenceIdentifier()');
    return userBox.get(homeGeofenceKey);
  }
}
