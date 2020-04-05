extension ExtensionDateTime on DateTime {
  bool isSameDay(DateTime date) {
    return this.day == date.day &&
        this.month == date.month &&
        this.year == date.year;
  }

  DateTime withoutMinAndSec() {
    return DateTime(this.year, this.month, this.day);
  }

  bool isToday() {
    return this.isSameDay(DateTime.now());
  }

  DateTime copyWith(
      {int day, int month, int year, int hour, int minute, int second}) {
    return DateTime(year ?? this.year, month ?? this.month, day ?? this.day,
        hour ?? this.hour, minute ?? this.minute, second ?? this.second);
  }

  int toMinutes() => this.hour * 60 + this.minute;
}
