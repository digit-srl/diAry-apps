import 'package:hive/hive.dart';
part 'annotation.g.dart';

@HiveType(typeId: 0)
class Annotation extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;

  Annotation(
      {this.title, this.dateTime, this.latitude, this.longitude, this.id});

  @override
  String toString() => 'id: $id, title: $title, dateTime: $dateTime';
}
