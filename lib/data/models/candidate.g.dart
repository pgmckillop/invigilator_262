// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CandidateAdapter extends TypeAdapter<Candidate> {
  @override
  final int typeId = 1;

  @override
  Candidate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Candidate(
      id: fields[0] as String,
      name: fields[1] as String,
      hasExtraTime: fields[2] as bool,
      breaksAllowed: fields[3] as bool,
      status: fields[4] as CandidateStatus,
      startTime: fields[5] as DateTime?,
      baseDurationMinutes: fields[6] as int,
      breaks: (fields[7] as List).cast<ExamBreak>(),
      finishedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Candidate obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hasExtraTime)
      ..writeByte(3)
      ..write(obj.breaksAllowed)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.baseDurationMinutes)
      ..writeByte(7)
      ..write(obj.breaks)
      ..writeByte(8)
      ..write(obj.finishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CandidateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CandidateStatusAdapter extends TypeAdapter<CandidateStatus> {
  @override
  final int typeId = 3;

  @override
  CandidateStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CandidateStatus.active;
      case 1:
        return CandidateStatus.onBreak;
      case 2:
        return CandidateStatus.finished;
      default:
        return CandidateStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, CandidateStatus obj) {
    switch (obj) {
      case CandidateStatus.active:
        writer.writeByte(0);
        break;
      case CandidateStatus.onBreak:
        writer.writeByte(1);
        break;
      case CandidateStatus.finished:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CandidateStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
