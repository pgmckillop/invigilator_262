// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_break.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamBreakAdapter extends TypeAdapter<ExamBreak> {
  @override
  final int typeId = 0;

  @override
  ExamBreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamBreak(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamBreak obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamBreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
