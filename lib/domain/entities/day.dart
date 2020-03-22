import 'note.dart';
import 'slice.dart';
import 'package:meta/meta.dart';

class Day {
  final DateTime date;
  final List<Slice> slices;
  final List<Note> notes;

//  final List<Location> notes;
  final pointCount;

  Day(
      {this.notes = const [],
      @required this.date,
      this.slices = const [],
      this.pointCount = 0});

  List<double> get annotationSlices {
    final list = <double>[];
    int cumulativeMinutes = 0;
    for (Note note in notes) {
      final currentMinutes = note.dateTime.hour * 60 + note.dateTime.minute;
      final partialMinutes = currentMinutes - cumulativeMinutes;
      list.add(partialMinutes.toDouble());
      list.add(0.0);
      cumulativeMinutes = currentMinutes;
    }
    if (cumulativeMinutes < 1440.0) {
      list.add(1440.0 - cumulativeMinutes);
    }
    return list;
  }

  copyWith(List<Slice> slices) {
    return Day(
        date: this.date, slices: slices ?? this.slices, notes: this.notes);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Date; $date, SlicesCount: ${slices.length} notesCount: ${notes.length}';
  }
}
