import 'package:state_notifier/state_notifier.dart';

import 'package:intl/intl.dart';
import 'package:diary/extensions.dart';

class DateState {
  final DateTime selectedDate;
//  final Map<DateTime, Day> _days;
  DateState(this.selectedDate);

  String get dateFormatted {
    final formatter = DateFormat('dd MMMM');
    return formatter.format(selectedDate);
  }

//  Day get selectedDay => _days[selectedDate];
//  List<DateTime> get dates => _days.keys.toList();
  bool get isToday => selectedDate.isToday();

  DateState copyWith({DateTime date}) {
    return DateState(date ?? this.selectedDate);
  }
}

class DateNotifier extends StateNotifier<DateState> with LocatorMixin {
  DateNotifier() : super(DateState(DateTime.now().withoutMinAndSec()));

  changeSelectedDate(DateTime selectedDate) {
    if (state.selectedDate != selectedDate) {
      state = state.copyWith(date: selectedDate);
    }
  }
}
