import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/utils/extensions.dart';
import 'package:diary/utils/constants.dart';
import 'package:hive/hive.dart';

abstract class UserLocalDataSources {
  bool isThereHomeGeofence();
  Future<void> setHomeGeofenceIdentifier(String identifier);
  String getHomeGeofenceIdentifier();
  Future<void> removeHomeGeofence();

  Future<void> saveUuid(String uuid);
  String getUserUuid();

  int getAnnotationCount(DateTime date);
}

class UserLocalDataSourcesImpl extends UserLocalDataSources {
  final Box userBox;

  UserLocalDataSourcesImpl(this.userBox);

  @override
  bool isThereHomeGeofence() {
    print('[UserLocalDataSources] isThereHomeGeofence()');
    final result = userBox.containsKey(homeGeofenceKey);
    print(result);
    return result;
  }

  @override
  Future<void> setHomeGeofenceIdentifier(String identifier) async {
    print('[UserLocalDataSources] setHomeGeofenceIdentifier()');
    await userBox.put(homeGeofenceKey, identifier);
  }

  @override
  Future<void> removeHomeGeofence() async {
    print('[UserLocalDataSources] removeHomeGeofence()');
    await userBox.delete(homeGeofenceKey);
  }

  @override
  String getHomeGeofenceIdentifier() {
    print('[UserLocalDataSources] getHomeGeofenceIdentifier()');
    return userBox.get(homeGeofenceKey);
  }

  @override
  String getUserUuid() {
    return userBox.get(userUuidKey);
  }

  @override
  Future<void> saveUuid(String uuid) async {
    await userBox.put(userUuidKey, uuid);
  }

  @override
  int getAnnotationCount(DateTime date) {
    return Hive.box<Annotation>('annotations')
        .values
        .where((a) => a.dateTime.isSameDay(date))
        .length;
  }
}
