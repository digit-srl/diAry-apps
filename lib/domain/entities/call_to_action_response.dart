import 'package:diary/utils/logger.dart';
import 'package:geodesy/geodesy.dart';
import 'package:hive/hive.dart';

part 'call_to_action_response.g.dart';

class CallToActionResponse {
  bool hasMatch;
  List<Call> calls;

  CallToActionResponse({this.hasMatch, this.calls});

  CallToActionResponse.fromJson(Map<String, dynamic> json) {
    hasMatch = json['hasMatch'];
    if (json['calls'] != null) {
      calls = new List<Call>();
      json['calls'].forEach((v) {
        calls.add(new Call.fromJson(v));
      });
    }
  }
}

@HiveType(typeId: 3)
class Call {
  @HiveField(0)
  String id;
  @HiveField(1)
  String description;
  @HiveField(2)
  String url;
  @HiveField(3)
  DateTime lastUpdate;
  @HiveField(4)
  List<Query> queries;
  @HiveField(5)
  bool opened;
  @HiveField(6)
  bool archived;
  @HiveField(7)
  bool executed;

  Call({
    this.id,
    this.description,
    this.url,
    this.queries,
    this.lastUpdate,
    this.archived = false,
    this.opened = false,
    this.executed = false,
  });

  Call.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    url = json['url'];
    lastUpdate = json['lastUpdate'];
    if (json['queries'] != null) {
      queries = new List<Query>();
      json['queries'].forEach((v) {
        queries.add(new Query.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'Call{' +
        ' id: $id,' +
        ' description: $description,' +
        ' url: $url,' +
        ' lastUpdate: $lastUpdate,' +
        ' queries: $queries,' +
        ' opened: $opened,' +
        ' archived: $archived,' +
        ' executed: $executed,' +
        '}';
  }

  Call copyWith({
    String id,
    String description,
    String url,
    DateTime lastUpdate,
    List<Query> queries,
    bool opened,
    bool archived,
    bool executed,
  }) {
    return Call(
      id: id ?? this.id,
      description: description ?? this.description,
      url: url ?? this.url,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      queries: queries ?? this.queries,
      opened: opened ?? this.opened,
      archived: archived ?? this.archived,
      executed: executed ?? this.executed,
    );
  }
}

@HiveType(typeId: 4)
class Query {
  @HiveField(0)
  String from;
  @HiveField(1)
  String to;
  @HiveField(2)
  Geometry geometry;

  Query({this.from, this.to, this.geometry});

  Query.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }
}

@HiveType(typeId: 5)
class Geometry {
  @HiveField(0)
  String type;
  @HiveField(1)
  List<Coordinates> coords;

  List<LatLng> get coordinates =>
      coords.map((c) => LatLng(c.lat, c.long)).toList();

  Geometry({this.type, this.coords});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      final polyList = List<List>.from(json['coordinates']);
      if (polyList.isNotEmpty) {
        coords = List<Coordinates>.from(
          polyList.first.map(
            (c) => Coordinates(long: c[0], lat: c[1]),
          ),
        );
      }
    }
  }
}

@HiveType(typeId: 6)
class Coordinates {
  @HiveField(0)
  double lat;
  @HiveField(1)
  double long;

  Coordinates({this.lat, this.long});
}
