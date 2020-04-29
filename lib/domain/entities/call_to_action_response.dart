import 'package:geodesy/geodesy.dart';

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
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['hasMatch'] = this.hasMatch;
//    if (this.calls != null) {
//      data['calls'] = this.calls.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
}

class Call {
  String id;
  String description;
  String url;
  List<Query> queries;

  Call({this.id, this.description, this.url, this.queries});

  Call.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    url = json['url'];
    if (json['queries'] != null) {
      queries = new List<Query>();
      json['queries'].forEach((v) {
        queries.add(new Query.fromJson(v));
      });
    }
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
//    data['description'] = this.description;
//    data['url'] = this.url;
//    if (this.queries != null) {
//      data['queries'] = this.queries.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
}

class Query {
  String from;
  String to;
  Geometry geometry;

  Query({this.from, this.to, this.geometry});

  Query.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['from'] = this.from;
//    data['to'] = this.to;
//    if (this.geometry != null) {
//      data['geometry'] = this.geometry.toJson();
//    }
//    return data;
//  }
}

class Geometry {
  String type;
  List<LatLng> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      List.from(json['coordinates']).forEach((v) {
        if (v.isNotEmpty) {
          v.forEach((c) {
            coordinates.add(LatLng(c[1], c[0]));
          });
        }
      });
    }
  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['type'] = this.type;
//    if (this.coordinates != null) {
//      data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
}
