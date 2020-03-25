// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnotationAdapter extends TypeAdapter<Annotation> {
  @override
  final typeId = 0;

  @override
  Annotation read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Annotation(
      title: fields[1] as String,
      dateTime: fields[2] as DateTime,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Annotation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude);
  }
}
