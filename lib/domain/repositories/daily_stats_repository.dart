import 'package:dartz/dartz.dart';
import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';

abstract class DailyStatsRepository {
  Future<Either<Failure, DailyStatsResponse>> sendDailyStats(
      DailyStats dailyStats);
}
