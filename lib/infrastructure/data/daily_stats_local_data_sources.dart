import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:hive/hive.dart';

abstract class DailyStatsLocalDataSources {
  Future saveDailyWom(DateTime dateTime, DailyStatsResponse dailyStatsResponse);
  bool isStatsSendedForThisDay(DateTime dateTime);
}

class DailyStatsLocalDataSourcesImpl extends DailyStatsLocalDataSources {
  final Box statsBox;

  DailyStatsLocalDataSourcesImpl(this.statsBox);
  @override
  Future<void> saveDailyWom(
      DateTime dateTime, DailyStatsResponse dailyStatsResponse) async {
    await statsBox.put(dateTime.toIso8601String(), dailyStatsResponse);
  }

  @override
  bool isStatsSendedForThisDay(DateTime dateTime) {
    return statsBox.containsKey(dateTime.toIso8601String());
  }
}
