// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final typeId = 1;

  @override
  Place read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as bool,
      fields[5] as double,
      fields[6] as double,
      fields[7] as double,
      enabled: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.identifier)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.isHome)
      ..writeByte(4)
      ..write(obj.enabled)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.radius);
  }
}
