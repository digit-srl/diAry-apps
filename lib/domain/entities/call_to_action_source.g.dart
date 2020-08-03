// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_to_action_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallToActionSourceAdapter extends TypeAdapter<CallToActionSource> {
  @override
  final typeId = 7;

  @override
  CallToActionSource read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallToActionSource(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CallToActionSource obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.source)
      ..writeByte(1)
      ..write(obj.sourceName)
      ..writeByte(2)
      ..write(obj.sourceDesc);
  }
}
