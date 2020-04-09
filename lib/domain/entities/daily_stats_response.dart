import 'package:hive/hive.dart';

part 'daily_stats_response.g.dart';

@HiveType(typeId: 2)
class DailyStatsResponse {
  @HiveField(0)
  String status;
  @HiveField(1)
  String womLink;
  @HiveField(2)
  String womPassword;
  @HiveField(3)
  int womCount;

  DailyStatsResponse(
      {this.status, this.womLink, this.womPassword, this.womCount});

  DailyStatsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    womLink = json['womLink'];
    womPassword = json['womPassword'];
    womCount = json['womCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['womLink'] = this.womLink;
    data['womPassword'] = this.womPassword;
    data['womCount'] = this.womCount;
    return data;
  }

  @override
  String toString() => '$womLink, $womPassword, $womCount';
}
