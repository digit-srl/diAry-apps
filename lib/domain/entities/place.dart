import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 1)
class Place extends HiveObject {
  @HiveField(0)
  final String identifier;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int color;
  @HiveField(3)
  final bool isHome;
  @HiveField(4)
  bool enabled;

  Place(this.identifier, this.name, this.color, this.isHome,
      {this.enabled = true});
}
