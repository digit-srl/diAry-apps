enum Event {
  On,
  Off,
  Geofence,
  MotionChange,
}

class Location {
  String uuid;
  Event event;
  DateTime dateTime;
  bool isMoving;
  bool sample;
  bool mock;
  double odometer;
  Coords coords;
  Activity activity;
  Battery battery;
  Extras extras;
  NetworkProvider provider;
  Geofence geofence;

  Location(
      {this.event,
      this.isMoving,
      this.sample,
      this.uuid,
//      this.timestamp,
      this.odometer,
      this.mock,
      this.coords,
      this.activity,
      this.battery,
      this.extras,
      this.provider,
      this.geofence});

  Event eventFromString(String event) {
    switch (event) {
      case 'ON':
        return Event.On;
      case 'OFF':
        return Event.Off;
      case 'motionchange':
        return Event.MotionChange;
      case 'geofence':
        return Event.Geofence;
      default:
        return null;
    }
  }

  String eventToString(Event event) {
    switch (event) {
      case Event.On:
        return 'ON';
      case Event.Off:
        return 'OFF';
      case Event.MotionChange:
        return 'motionchange';
      case Event.Geofence:
        return 'geofence';
      default:
        return null;
    }
  }

  Location.fromJson(Map<String, dynamic> json) {
    event = eventFromString(json['event']);
    isMoving = json['is_moving'];
    isMoving = json['sample'];
    uuid = json['uuid'];
//    timestamp = json['timestamp'];
    dateTime = json['timestamp'] != null
        ? DateTime.parse(json['timestamp']).toLocal()
        : null;
    odometer = json['odometer']?.toDouble();
    mock = json['mock'];
    coords = json['coords'] != null
        ? new Coords.fromJson(Map<String, dynamic>.from(json['coords']))
        : null;
    activity = json['activity'] != null
        ? new Activity.fromJson(Map<String, dynamic>.from(json['activity']))
        : null;
    battery = json['battery'] != null
        ? new Battery.fromJson(Map<String, dynamic>.from(json['battery']))
        : null;
    extras = json['extras'] != null
        ? new Extras.fromJson(Map<String, dynamic>.from(json['extras']))
        : null;
    provider = json['provider'] != null
        ? new NetworkProvider.fromJson(
            Map<String, dynamic>.from(json['provider']))
        : null;
    geofence = json['geofence'] != null
        ? new Geofence.fromJson(Map<String, dynamic>.from(json['geofence']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = eventToString(this.event);
    data['is_moving'] = this.isMoving;
    data['sample'] = this.sample;
    data['uuid'] = this.uuid;
//    data['timestamp'] = this.timestamp;
    data['timestamp'] = this.dateTime.toUtc().toIso8601String();
    data['odometer'] = this.odometer;
    data['mock'] = this.mock;
    data['coords'] = this.coords?.toJson();
    data['activity'] = this.activity?.toJson();
    data['battery'] = this.battery?.toJson();
    data['extras'] = this.extras?.toJson();
    data['provider'] = this.provider?.toJson();
    data['geofence'] = this.geofence?.toJson();
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'uuid: $uuid';
  }
}

class Coords {
  int floor;
  double latitude;
  double longitude;
  double accuracy;
  double altitude;
  double heading;
  double speed;
  double altitudeAccuracy;

  Coords(
      {this.latitude,
      this.longitude,
      this.accuracy,
      this.speed,
      this.heading,
      this.altitude});

  Coords.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    accuracy = json['accuracy']?.toDouble();
    speed = json['speed']?.toDouble();
    heading = json['heading']?.toDouble();
    altitude = json['altitude']?.toDouble();
    if (json['altitude_accuracy'] != null) {
      this.altitudeAccuracy = json['altitude_accuracy'] * 1.0;
    }
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['accuracy'] = this.accuracy;
    data['speed'] = this.speed;
    data['heading'] = this.heading;
    data['altitude'] = this.altitude;
    data['floor'] = this.floor;
    return data;
  }
}

class Activity {
  String type;
  double confidence;

  Activity({this.type, this.confidence});

  Activity.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    confidence = json['confidence']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['confidence'] = this.confidence;
    return data;
  }
}

class Battery {
  bool isCharging;
  double level;

  Battery({this.isCharging, this.level});

  Battery.fromJson(Map<String, dynamic> json) {
    isCharging = json['is_charging'];
    level = json['level']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_charging'] = this.isCharging;
    data['level'] = this.level;
    return data;
  }
}

class NetworkProvider {
  bool network;
  bool gps;
  bool enabled;
  int status;

  NetworkProvider({this.network, this.gps, this.enabled, this.status});

  NetworkProvider.fromJson(Map<String, dynamic> json) {
    network = json['network'];
    gps = json['gps'];
    enabled = json['enabled'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['network'] = this.network;
    data['gps'] = this.gps;
    data['enabled'] = this.enabled;
    data['status'] = this.status;
    return data;
  }
}

class Geofence {
  String identifier;
  String action;
  Extras extras;

  Geofence({this.identifier, this.action, this.extras});

  Geofence.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    action = json['action'];
    extras = json['extras'] != null
        ? new Extras.fromJson(Map<String, dynamic>.from(json['extras']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['action'] = this.action;
    data['extras'] = this.extras?.toJson();
    return data;
  }
}

class Extras {
  CenterCoords center;
  double radius;
  String event;
  bool enabled;
  String name;
  int color;
  bool isHome;

  Extras(
      {this.center,
      this.radius,
      this.event,
      this.enabled,
      this.name,
      this.color,
      this.isHome});

  Extras.fromJson(Map<String, dynamic> json) {
    center = json['center'] != null
        ? new CenterCoords.fromJson(Map<String, dynamic>.from(json['center']))
        : null;
    radius = json['radius']?.toDouble();
    event = json['event'];
    name = json['name'];
    color = json['color'];
    isHome = json['isHome'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center'] = this.center?.toJson();
    data['radius'] = this.radius;
    data['enabled'] = this.enabled;
    data['name'] = this.name;
    data['color'] = this.color;
    data['isHome'] = this.isHome;
    data['event'] = this.event;
    data.removeWhere((key, element) => element == null);
    return data;
  }
}

class CenterCoords {
  double latitude;
  double longitude;

  CenterCoords({this.latitude, this.longitude});

  CenterCoords.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
