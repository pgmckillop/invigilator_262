import 'package:hive/hive.dart';
import 'exam_break.dart';

part 'candidate.g.dart';

@HiveType(typeId: 3)
enum CandidateStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  onBreak,
  @HiveField(2)
  finished
}

@HiveType(typeId: 1)
class Candidate {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool hasExtraTime;

  @HiveField(3)
  final bool breaksAllowed;

  @HiveField(4)
  final CandidateStatus status;

  @HiveField(5)
  final DateTime? startTime;

  @HiveField(6)
  final int baseDurationMinutes;

  @HiveField(7)
  final List<ExamBreak> breaks;

  @HiveField(8)
  final DateTime? finishedAt;

  Candidate({
    required this.id,
    required this.name,
    this.hasExtraTime = false,
    this.breaksAllowed = true,
    this.status = CandidateStatus.active,
    this.startTime,
    required this.baseDurationMinutes,
    this.breaks = const [],
    this.finishedAt,
  });

  /// Calculates the total duration allowed including extra time
  Duration get totalAllowedDuration {
    final multiplier = hasExtraTime ? 1.25 : 1.0;
    return Duration(seconds: (baseDurationMinutes * 60 * multiplier).toInt());
  }

  /// Sum of all break durations
  Duration get totalBreakDuration {
    return breaks.fold(Duration.zero, (total, b) => total + b.duration);
  }

  /// Logic for Candidate C: Returns the actual end time adjusted for breaks
  DateTime? calculateEndTime(Duration globalPauseOffset) {
    if (startTime == null) return null;
    return startTime!
        .add(totalAllowedDuration)
        .add(totalBreakDuration)
        .add(globalPauseOffset);
  }

  Candidate copyWith({
    CandidateStatus? status,
    List<ExamBreak>? breaks,
    DateTime? finishedAt,
    DateTime? startTime,
  }) {
    return Candidate(
      id: id,
      name: name,
      hasExtraTime: hasExtraTime,
      breaksAllowed: breaksAllowed,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      baseDurationMinutes: baseDurationMinutes,
      breaks: breaks ?? this.breaks,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}
