import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:intl/intl.dart';
import 'package:diary/utils/extensions.dart';

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
  final Map<DateTime, Day> days;
  static DateTime openAppDate = DateTime.now().withoutMinAndSec();

  DayNotifier(this.days)
      : super(DayState(days[DateTime.now().withoutMinAndSec()]));

  changeDay(DateTime selectedDate) {
    if (state.day.date != selectedDate) {
      read<DateNotifier>().changeSelectedDate(selectedDate);
      state = DayState(days[selectedDate]);
    }
  }

  updateDay(Location location, DateTime date) {
    if (!days.containsKey(date)) {
      days[date] = Day(date: date);
    }
    final partialSlices = days[date]?.slices ?? [];
    final newSlices = LocationUtils.aggregateLocationsInSlices(
      [location],
      partialDaySlices: date.isSameDay(openAppDate) && partialSlices.isNotEmpty
          ? partialSlices.sublist(0, partialSlices.length - 1)
          : partialSlices,
    );
    days[date] = days[date].copyWith(newSlices, 1);

    if (state.day.date.isSameDay(openAppDate)) {
      if (date.isAfter(openAppDate)) {
        read<DateNotifier>().changeSelectedDate(date);
        openAppDate = date;
      }
      state = DayState(days[date]);
    }
  }

  void addAnnotation(Annotation annotation) {
    final date = annotation.dateTime.withoutMinAndSec();
    days[date] = days[date].copyWithNewAnnotation(annotation);
    if (state.day.date.isSameDay(annotation.dateTime)) {
      state = DayState(days[date]);
    }
  }
}
