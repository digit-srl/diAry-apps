import 'package:hive/hive.dart';

part 'call_to_action_source.g.dart';

@HiveType(typeId: 7)
class CallToActionSource {
  @HiveField(0)
  final String source;
  @HiveField(1)
  final String sourceName;

  CallToActionSource(this.source, this.sourceName);
}
