import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/utils/extensions.dart';
import 'package:diary/utils/constants.dart';
import 'package:diary/utils/logger.dart';
import 'package:hive/hive.dart';

abstract class UserLocalDataSources {
  bool isThereHomeGeofence();
  Future<void> setHomeGeofenceIdentifier(String identifier);
  String getHomeGeofenceIdentifier();
  Future<void> removeHomeGeofence();

  Future<void> saveUuid(String uuid);
  String getUserUuid();

  int getAnnotationCount(DateTime date);

  DateTime getLastCallToActionDate();
  Future<void> saveCallToActionDate(DateTime dateTime);
}

class UserLocalDataSourcesImpl extends UserLocalDataSources {
  final Box userBox;

  UserLocalDataSourcesImpl(this.userBox);

  @override
  bool isThereHomeGeofence() {
    logger.i('[UserLocalDataSources] isThereHomeGeofence()');
    final result = userBox.containsKey(homeGeofenceKey);
    logger.i(result);
    return result;
  }

  @override
  Future<void> setHomeGeofenceIdentifier(String identifier) async {
    logger.i('[UserLocalDataSources] setHomeGeofenceIdentifier()');
    await userBox.put(homeGeofenceKey, identifier);
  }

  @override
  Future<void> removeHomeGeofence() async {
    logger.i('[UserLocalDataSources] removeHomeGeofence()');
    await userBox.delete(homeGeofenceKey);
  }

  @override
  String getHomeGeofenceIdentifier() {
    logger.i('[UserLocalDataSources] getHomeGeofenceIdentifier()');
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

  @override
  DateTime getLastCallToActionDate() {
    return userBox.get('lastCallToAction');
  }

  @override
  Future<void> saveCallToActionDate(DateTime dateTime) async {
    await userBox.put('lastCallToAction', dateTime);
  }
}
