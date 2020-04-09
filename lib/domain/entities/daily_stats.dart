import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class DailyStats {
  DateTime date;
  String installationId;
  String centroidHash;
  int totalMinutesTracked; // minuti in ON
  int locationCount; //n. di geofence
  int vehicleCount;
  int eventCount; //n. di annotazioni
  int sampleCount;
  int discardedSampleCount;
  double boundingBoxDiagonal;
  LocationTracking locationTracking;
//  MovementTracking movementTracking;
  String formattedDate;

  DailyStats({
    @required this.installationId,
    @required this.date,
    @required this.totalMinutesTracked,
    @required this.centroidHash,
    @required this.locationCount,
    this.vehicleCount = 0,
    @required this.eventCount,
    @required this.locationTracking,
    @required this.sampleCount,
    @required this.discardedSampleCount,
    @required this.boundingBoxDiagonal,
//      this.movementTracking,
  }) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    formattedDate = dateFormat.format(this.date);
  }

//  DailyStats.fromJson(Map<String, dynamic> json) {
//    installationId = json['installationId'];
//    date = json['date'];
//    totalMinutesTracked = json['totalMinutesTracked'];
//    centroidHash = json['centroidHash'];
//    locationCount = json['locationCount'];
//    vehicleCount = json['vehicleCount'];
//    eventCount = json['eventCount'];
//    locationTracking = json['locationTracking'] != null
//        ? new LocationTracking.fromJson(json['locationTracking'])
//        : null;
//    movementTracking = json['movementTracking'] != null
//        ? new MovementTracking.fromJson(json['movementTracking'])
//        : null;
//  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['installationId'] = this.installationId;

    final utcDate = this.date.isUtc ? this.date : this.date.toUtc();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    data['date'] = dateFormat.format(utcDate);
    data['totalMinutesTracked'] = this.totalMinutesTracked;
    data['centroidHash'] = this.centroidHash;
    data['locationCount'] = this.locationCount;
    data['vehicleCount'] = this.vehicleCount;
    data['eventCount'] = this.eventCount;
    data['sampleCount'] = this.sampleCount;
    data['discardedSampleCount'] = this.discardedSampleCount;
    data['boundingBoxDiagonal'] = this.boundingBoxDiagonal;

    if (this.locationTracking != null) {
      data['locationTracking'] = this.locationTracking.toJson();
    }
//    if (this.movementTracking != null) {
//      data['movementTracking'] = this.movementTracking.toJson();
//    }
//    data.removeWhere((k, v) => v == null);
    return data;
  }
}

class LocationTracking {
  int minutesAtHome;
  int minutesAtWork;
  int minutesAtSchool;
  int minutesAtOtherKnownLocations; //somma dei minuti nei luoghi salvati (geofence) escluso CASA, AT_WORK, AT_SCHOOL
  int minutesElsewhere; //

  LocationTracking({
    @required this.minutesAtHome,
    this.minutesAtWork = 0,
    this.minutesAtSchool = 0,
    @required this.minutesAtOtherKnownLocations,
    @required this.minutesElsewhere,
  });

  LocationTracking.fromJson(Map<String, dynamic> json) {
    minutesAtHome = json['minutesAtHome'];
    minutesAtWork = json['minutesAtWork'];
    minutesAtSchool = json['minutesAtSchool'];
    minutesAtOtherKnownLocations = json['minutesAtOtherKnownLocations'];
    minutesElsewhere = json['minutesElsewhere'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minutesAtHome'] = this.minutesAtHome;
    data['minutesAtWork'] = this.minutesAtWork;
    data['minutesAtSchool'] = this.minutesAtSchool;
    data['minutesAtOtherKnownLocations'] = this.minutesAtOtherKnownLocations;
    data['minutesElsewhere'] = this.minutesElsewhere;
//    data.removeWhere((k, v) => v == null);
    return data;
  }
}

//class MovementTracking {
//  int static;
//  int vehicle;
//  int bicycle;
//  int onFoot;
//
//  MovementTracking({this.static, this.vehicle, this.bicycle, this.onFoot});
//
//  MovementTracking.fromJson(Map<String, dynamic> json) {
//    static = json['static'];
//    vehicle = json['vehicle'];
//    bicycle = json['bicycle'];
//    onFoot = json['onFoot'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['static'] = this.static;
//    data['vehicle'] = this.vehicle;
//    data['bicycle'] = this.bicycle;
//    data['onFoot'] = this.onFoot;
//    data.removeWhere((k, v) => v == null);
//    return data;
//  }
//}
