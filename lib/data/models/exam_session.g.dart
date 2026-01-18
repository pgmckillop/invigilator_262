// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamSessionAdapter extends TypeAdapter<ExamSession> {
  @override
  final int typeId = 2;

  @override
  ExamSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamSession(
      id: fields[0] as String,
      status: fields[1] as SessionStatus,
      baseDurationMinutes: fields[2] as int,
      startTime: fields[3] as DateTime?,
      globalPauseStartTime: fields[4] as DateTime?,
      totalGlobalPauseDuration: fields[5] as Duration,
      candidates: (fields[6] as List).cast<Candidate>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExamSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.baseDurationMinutes)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.globalPauseStartTime)
      ..writeByte(5)
      ..write(obj.totalGlobalPauseDuration)
      ..writeByte(6)
      ..write(obj.candidates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionStatusAdapter extends TypeAdapter<SessionStatus> {
  @override
  final int typeId = 4;

  @override
  SessionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionStatus.idle;
      case 1:
        return SessionStatus.running;
      case 2:
        return SessionStatus.paused;
      case 3:
        return SessionStatus.stopped;
      default:
        return SessionStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, SessionStatus obj) {
    switch (obj) {
      case SessionStatus.idle:
        writer.writeByte(0);
        break;
      case SessionStatus.running:
        writer.writeByte(1);
        break;
      case SessionStatus.paused:
        writer.writeByte(2);
        break;
      case SessionStatus.stopped:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
