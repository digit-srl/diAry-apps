import 'package:dartz/dartz.dart';

import 'package:diary/core/errors/failures.dart';
import 'package:diary/core/errors/exceptions.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/domain/repositories/daily_stats_repository.dart';
import 'package:diary/infrastructure/data/daily_stats_local_data_sources.dart';
import 'package:diary/infrastructure/data/daily_stats_remote_data_sources.dart';
import 'package:diary/utils/logger.dart';

class DailyStatsRepositoryImpl extends DailyStatsRepository {
  final DailyStatsLocalDataSources dailyStatsLocalDataSources;
  final DailyStatsRemoteDataSources dailyStatsRemoteDataSources;

  DailyStatsRepositoryImpl(
      this.dailyStatsLocalDataSources, this.dailyStatsRemoteDataSources);

  @override
  Future<Either<Failure, DailyStatsResponse>> sendDailyStats(
      DailyStats dailyStats) async {
    try {
      final response =
          await dailyStatsRemoteDataSources.sendDailyStats(dailyStats);
      await dailyStatsLocalDataSources.saveDailyWom(dailyStats.date, response);
      return Right(response);
    } on ConflictDay {
      return Left(ConflictDayFailure());
    } on UnprocessableEntity {
      return Left(UnprocessableDayFailure());
    } catch (ex) {
      logger.e(ex);
      return Left(UnknownFailure(ex.toString()));
    }
  }
}
