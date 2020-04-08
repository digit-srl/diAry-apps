import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/repositories/daily_stats_repository.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:diary/infrastructure/repositories/daily_stats_repository_impl.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:uuid/uuid.dart';

import 'date_notifier.dart';
import 'day_notifier.dart';

part 'upload_stats_notifier.freezed.dart';

class UploadStatsNotifier extends StateNotifier<UploadStatsState>
    with LocatorMixin {
  final DailyStats dailyStats;
  final DailyStatsResponse dailyStatsResponse;
  UploadStatsNotifier(this.dailyStats, this.dailyStatsResponse)
      : super(dailyStatsResponse == null
            ? Initial()
            : WomResponse(dailyStatsResponse));

  sendDailyStats(DailyStats dailyStats) async {
    state = Loading();
    await Future.delayed(Duration(seconds: 2));
//    state = WomResponse(DailyStatsResponse(
//        womLink: 'https://google.com', womPassword: '1231', womCount: 24));
    final responseEither =
        await read<DailyStatsRepositoryImpl>().sendDailyStats(dailyStats);
    responseEither.fold((failure) {
      state = ErrorDetails(_mapFailureToMessage(failure));
    }, (response) {
      read<DayNotifier>().addWomResponseToDay(response);
      state = WomResponse(response);
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ConflictDayFailure:
        return 'I dati di questo giorno sono stati già inviati';
      case UnprocessableDayFailure:
        return 'Errore nella richiesta';
      case UnknownFailure:
        return 'Errore: ${(failure as UnknownFailure).message}';
      default:
        return 'Unexpected error';
    }
  }
}

@freezed
abstract class UploadStatsState with _$UploadStatsState {
  const factory UploadStatsState.initial() = Initial;
  const factory UploadStatsState.loading() = Loading;
  const factory UploadStatsState.error([String message]) = ErrorDetails;
  const factory UploadStatsState.womResponse(DailyStatsResponse value) =
      WomResponse;
}
