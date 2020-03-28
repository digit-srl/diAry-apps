import 'package:diary/domain/entities/annotation.dart';

import 'slice.dart';
import 'package:meta/meta.dart';

class Day {
  final DateTime date;
  final List<Slice> slices;
  final List<Annotation> annotations;

//  final List<Location> notes;
  final pointCount;

  Day(
      {this.annotations = const [],
      @required this.date,
      this.slices = const [],
      this.pointCount = 0});

  List<double> get annotationSlices {
    final list = <double>[];
    int cumulativeMinutes = 0;
    for (Annotation note in annotations) {
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

  copyWith(List<Slice> slices, [int newPoints = 0]) {
    return Day(
        date: this.date,
        slices: slices ?? this.slices,
        annotations: this.annotations,
        pointCount: this.pointCount + newPoints);
  }

  copyWithNewAnnotation(Annotation annotation) {
    final list = List.from(annotations);
    list.add(annotation);
    return Day(
        date: this.date,
        slices: this.slices,
        annotations: list,
        pointCount: this.pointCount);
  }

  @override
  String toString() {
    return 'Date; $date, SlicesCount: ${slices.length} notesCount: ${annotations.length}';
  }
}
