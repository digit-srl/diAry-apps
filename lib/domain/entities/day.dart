import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:hive/hive.dart';
import 'slice.dart';
import 'package:meta/meta.dart';

class Day {
  final DateTime date;
  final List<Slice> slices;
  final List<Slice> places;
  List<Annotation> annotations;
  final DailyStatsResponse dailyStatsResponse;
  final int sampleCount;
  final int discardedSampleCount;
  final String centroidHash;
  final double boundingBoxDiagonal;
//  final pointCount;
  int wom;

  bool get isStatsSended => dailyStatsResponse != null;

  Day({
    this.annotations = const [],
    @required this.date,
    this.slices = const [],
    this.places = const [],
    this.sampleCount,
    this.discardedSampleCount,
    this.centroidHash,
//    this.pointCount = 0,
    this.dailyStatsResponse,
    this.boundingBoxDiagonal,
  }) {
    wom = GenericUtils.getWomCountForThisDay(places);
  }

  int get locationCount {
    final list = <String>{};
    places.forEach((p) => list.addAll(p.places));
    return list.length;
  }

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

  copyWith({
    List<Slice> slices,
    List<Slice> places,
    List<Annotation> annotations,
    DailyStatsResponse response,
    int newPoints = 0,
  }) {
    return Day(
      date: this.date,
      slices: slices ?? this.slices,
      places: places ?? this.places,
      annotations: annotations ?? this.annotations,
//      pointCount: this.pointCount + newPoints,
//      dailyStats: this.dailyStats,
      dailyStatsResponse: response ?? this.dailyStatsResponse,
      sampleCount: this.sampleCount,
      discardedSampleCount: this.discardedSampleCount,
      centroidHash: this.centroidHash,
      boundingBoxDiagonal: this.boundingBoxDiagonal,
    );
  }

  Set<Place> get geofences {
    final Set<Place> list = {};
    final box = Hive.box<Place>('places');
    this.places.forEach(
      (place) {
        place.places.forEach(
          (identifier) {
            list.add(box.get(identifier));
          },
        );
      },
    );
    return list;
  }

  copyWithAnnotationAction(Annotation annotation, AnnotationAction action) {
    final list = List<Annotation>.from(annotations);
    if (action == AnnotationAction.Added) {
      list.add(annotation);
    } else if (action == AnnotationAction.Removed) {
      list.removeWhere((a) => a.id == annotation.id);
    }

    return Day(
      date: this.date,
      slices: this.slices,
      places: this.places,
      annotations: list,
//      pointCount: this.pointCount,
//      dailyStats: this.dailyStats,
      dailyStatsResponse: this.dailyStatsResponse,
      sampleCount: this.sampleCount,
      discardedSampleCount: this.discardedSampleCount,
      centroidHash: this.centroidHash,
      boundingBoxDiagonal: this.boundingBoxDiagonal,
    );
  }

  @override
  String toString() {
    return 'Date; $date, SlicesCount: ${slices.length} notesCount: ${annotations.length}';
  }
}
