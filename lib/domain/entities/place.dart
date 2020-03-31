import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 1)
class Place extends HiveObject {
  @HiveField(0)
  final String identifier;
  @HiveField(1)
  String name;
  @HiveField(2)
  int color;
  @HiveField(3)
  bool isHome;
  @HiveField(4)
  bool enabled;
  @HiveField(5)
  double latitude;
  @HiveField(6)
  double longitude;
  @HiveField(7)
  double radius;

  Place(this.identifier, this.name, this.color, this.isHome, this.latitude,
      this.longitude, this.radius,
      {this.enabled = true});
}
