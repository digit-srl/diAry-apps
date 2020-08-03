abstract class UserRepository {
  bool isThereHomeGeofence();
  Future<void> setHomeGeofenceIdentifier(String identifier);
  String getHomeGeofenceIdentifier();
  Future<void> removeHomeGeofence();
  Future<String> getUserUuid();
  int getDailyAnnotationCount(DateTime date);
  DateTime getLastCallToActionDate();
  Future<void> saveCallToActionDate(DateTime dateTime);
}
