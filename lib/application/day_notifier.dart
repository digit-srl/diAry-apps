import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:intl/intl.dart';
import 'package:diary/utils/extensions.dart';
import 'package:uuid/uuid.dart';

import 'date_notifier.dart';

class DayState {
  final Day day;

  DayState(this.day);

  String get dateFormatted {
    final formatter = DateFormat('dd MMMM');
    return formatter.format(day.date);
  }

  bool get isToday => day.date.isToday();
}

class DayNotifier extends StateNotifier<DayState> with LocatorMixin {
  Map<DateTime, Day> days;
  final LocationRepository locationRepository;
  static DateTime openAppDate = DateTime.now().withoutMinAndSec();

  DayNotifier(this.days, this.locationRepository)
      : super(DayState(days[DateTime.now().withoutMinAndSec()]));

  @override
  void update(T Function<T>() watch) {
    final AnnotationState annotationState = watch<AnnotationState>();
    manageAnnotation(annotationState);
  }

  changeDay(DateTime selectedDate) {
    if (state.day.date != selectedDate) {
      read<DateNotifier>().changeSelectedDate(selectedDate);
      state = DayState(days[selectedDate]);
    }
  }

  void processAllLocations() async {
    final Map<DateTime, List<Location>> locationsPerDate =
        await locationRepository.readAndFilterLocationsPerDay();
    final newDays =
        LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);

    final today = DateTime.now().withoutMinAndSec();
    if (!newDays.containsKey(today)) {
      newDays[today] = Day(date: today);
    }
    this.days = newDays;
    state = DayState(days[read<DateNotifier>().selectedDate]);
  }

  void updateDay2(
      Map<DateTime, List<Location>> locationsPerDate, DateTime date) {
    if (!days.containsKey(date)) {
      days[date] = Day(date: date);
    }

    if (date.isAfter(openAppDate)) {
      final yesterdayAggregation = LocationUtils.aggregateLocationsInSlices3(
        date: openAppDate,
        locations: locationsPerDate[openAppDate],
      );
      yesterdayAggregation.annotations = days[openAppDate]?.annotations ?? [];
      days[openAppDate] = yesterdayAggregation;
    }
    final aggregationData = LocationUtils.aggregateLocationsInSlices3(
      date: date,
      locations: locationsPerDate[date],
    );
    aggregationData.annotations = days[date]?.annotations ?? [];
    days[date] = aggregationData;

    // Am I seeing same day of opened app date? -> update the ui
    if (state.day.date.isSameDay(openAppDate)) {
      // Is locations after (next day) open app date? -> update the app bar and pass to new date
      if (date.isAfter(openAppDate)) {
        read<DateNotifier>().changeSelectedDate(date);
        openAppDate = date;
      }
      state = DayState(days[date]);
    }
  }

//old method
//  void updateDay(Location location, DateTime date) {
//    if (!days.containsKey(date)) {
//      days[date] = Day(date: date);
//    }
//    final partialSlices = days[date]?.slices ?? [];
//    final partialPlaces = days[date]?.places ?? [];
//    final aggregationData = LocationUtils.aggregateLocationsInSlices3(
//      [location],
//      partialDaySlices: date.isSameDay(openAppDate) && partialSlices.isNotEmpty
//          ? partialSlices.sublist(
//              0,
//              partialSlices.length -
//                  1) // Pass partial list withou Unknown slice (used to show future hours in today)
//          : partialSlices,
//      partialDayPlaces: date.isSameDay(openAppDate) && partialPlaces.isNotEmpty
//          ? partialPlaces.sublist(
//              0,
//              partialPlaces.length -
//                  1) // Pass partial list withou Unknown slice (used to show future hours in today)
//          : partialPlaces,
//    );
//    days[date] = days[date].copyWith(
//        slices: aggregationData.slices,
//        places: aggregationData.places,
//        newPoints: 1);
//
//    if (state.day.date.isSameDay(openAppDate)) {
//      if (date.isAfter(openAppDate)) {
//        read<DateNotifier>().changeSelectedDate(date);
//        openAppDate = date;
//      }
//      state = DayState(days[date]);
//    }
//  }

  void manageAnnotation(AnnotationState annotationState) {
    logger.i('[DayNotifier] addAnnotation() $annotationState');
    if (annotationState != null) {
      final date = annotationState.annotation.dateTime.withoutMinAndSec();
      days[date] = days[date].copyWithAnnotationAction(
          annotationState.annotation, annotationState.action);
      if (state.day.date.isSameDay(annotationState.annotation.dateTime)) {
        state = DayState(days[date]);
      }
    }
  }

  Future<DailyStats> buildDailyStats() async {
    logger.i('[UploadStatsNotifier] sendDailyStats()');
    final day = state.day;
    final uuid = await read<UserRepositoryImpl>().getUserUuid();
    DateTime date = read<DateNotifier>().selectedDate;
    // TODO leggere anche gli id dei precedenti luoghi intesi come "CASA"
    // altrimenti cambianddo casa l algo non riconosce i luoghi impostati
    // come CASA nei giorni passati
    final homeIdentifier =
        read<UserRepositoryImpl>().getHomeGeofenceIdentifier();
    final eventCount = read<UserRepositoryImpl>().getDailyAnnotationCount(date);
    final int minutesAtHome =
        GenericUtils.getHomeMinutes(day.places, homeIdentifier);
    final int totalMinutesTracked =
        GenericUtils.getTotalMinutesTracked(day.places);
    final int minutesElseWhere = GenericUtils.getMinutesElsewhere(day.places);
    final int minutesAtOtherKnownLocations =
        GenericUtils.getMinutesAtOtherKnownLocations(
            day.places, homeIdentifier);
    final dailyStats = DailyStats(
        installationId: uuid,
        date: date,
        locationTracking: LocationTracking(
          minutesAtHome: minutesAtHome,
          minutesElsewhere: minutesElseWhere,
          minutesAtOtherKnownLocations: minutesAtOtherKnownLocations,
        ),
        centroidHash: day.centroidHash,
        totalMinutesTracked: totalMinutesTracked,
        eventCount: eventCount,
        locationCount: day.locationCount,
        sampleCount: day.sampleCount,
        discardedSampleCount: day.discardedSampleCount,
        boundingBoxDiagonal: day.boundingBoxDiagonal);
    return dailyStats;
  }

  void addWomResponseToDay(DailyStatsResponse response) {
    state = DayState(state.day.copyWith(response: response));
  }
}
