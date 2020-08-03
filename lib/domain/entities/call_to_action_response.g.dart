// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_to_action_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallAdapter extends TypeAdapter<Call> {
  @override
  final typeId = 3;

  @override
  Call read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Call(
      id: fields[0] as String,
      description: fields[1] as String,
      url: fields[2] as String,
      queries: (fields[4] as List)?.cast<Query>(),
      lastUpdate: fields[3] as DateTime,
      source: fields[9] as String,
      sourceName: fields[10] as String,
      sourceDesc: fields[11] as String,
      maxTime: fields[12] as int,
      archived: fields[6] as bool,
      opened: fields[5] as bool,
      executed: fields[7] as bool,
    )..insertedDate = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Call obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.lastUpdate)
      ..writeByte(4)
      ..write(obj.queries)
      ..writeByte(5)
      ..write(obj.opened)
      ..writeByte(6)
      ..write(obj.archived)
      ..writeByte(7)
      ..write(obj.executed)
      ..writeByte(8)
      ..write(obj.insertedDate)
      ..writeByte(9)
      ..write(obj.source)
      ..writeByte(10)
      ..write(obj.sourceName)
      ..writeByte(11)
      ..write(obj.sourceDesc)
      ..writeByte(12)
      ..write(obj.maxTime);
  }
}

class QueryAdapter extends TypeAdapter<Query> {
  @override
  final typeId = 4;

  @override
  Query read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    try {
      return Query(
        from: fields[3] as DateTime,
        to: fields[4] as DateTime,
        geometry: fields[2] as Geometry,
        fromS: fields[0] as String,
        toS: fields[1] as String,
      );
    } catch (ex) {
      logger.e(ex);
      final now = DateTime.now();
      return Query(
        from: now,
        to: now.add(Duration(hours: 1)),
        geometry: fields[2] as Geometry,
        fromS: now.toIso8601String(),
        toS: now.toIso8601String(),
      );
    }
  }

  @override
  void write(BinaryWriter writer, Query obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fromS)
      ..writeByte(1)
      ..write(obj.toS)
      ..writeByte(2)
      ..write(obj.geometry)
      ..writeByte(3)
      ..write(obj.from)
      ..writeByte(4)
      ..write(obj.to);
  }
}

class GeometryAdapter extends TypeAdapter<Geometry> {
  @override
  final typeId = 5;

  @override
  Geometry read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Geometry(
      type: fields[0] as String,
      coords: (fields[1] as List)?.cast<Coordinates>(),
    );
  }

  @override
  void write(BinaryWriter writer, Geometry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.coords);
  }
}

class CoordinatesAdapter extends TypeAdapter<Coordinates> {
  @override
  final typeId = 6;

  @override
  Coordinates read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coordinates(
      lat: fields[0] as double,
      long: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Coordinates obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long);
  }
}
