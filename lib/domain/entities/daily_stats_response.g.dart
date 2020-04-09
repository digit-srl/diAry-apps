// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stats_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStatsResponseAdapter extends TypeAdapter<DailyStatsResponse> {
  @override
  final typeId = 2;

  @override
  DailyStatsResponse read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStatsResponse(
      status: fields[0] as String,
      womLink: fields[1] as String,
      womPassword: fields[2] as String,
      womCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyStatsResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.womLink)
      ..writeByte(2)
      ..write(obj.womPassword)
      ..writeByte(3)
      ..write(obj.womCount);
  }
}
