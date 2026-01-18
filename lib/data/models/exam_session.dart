import 'package:hive/hive.dart';
import 'candidate.dart';

part 'exam_session.g.dart';

@HiveType(typeId: 4)
enum SessionStatus {
  @HiveField(0)
  idle,
  @HiveField(1)
  running,
  @HiveField(2)
  paused,
  @HiveField(3)
  stopped
}

@HiveType(typeId: 2)
class ExamSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final SessionStatus status;

  @HiveField(2)
  final int baseDurationMinutes;

  @HiveField(3)
  final DateTime? startTime;

  @HiveField(4)
  final DateTime? globalPauseStartTime;

  @HiveField(5)
  final Duration totalGlobalPauseDuration;

  @HiveField(6)
  final List<Candidate> candidates;

  ExamSession({
    required this.id,
    this.status = SessionStatus.idle,
    required this.baseDurationMinutes,
    this.startTime,
    this.globalPauseStartTime,
    this.totalGlobalPauseDuration = Duration.zero,
    this.candidates = const [],
  });

  Duration get currentGlobalOffset {
    if (status == SessionStatus.paused && globalPauseStartTime != null) {
      return totalGlobalPauseDuration +
          DateTime.now().difference(globalPauseStartTime!);
    }
    return totalGlobalPauseDuration;
  }

  ExamSession copyWith({
    SessionStatus? status,
    DateTime? startTime,
    DateTime? globalPauseStartTime,
    Duration? totalGlobalPauseDuration,
    List<Candidate>? candidates,
    int? baseDurationMinutes,
  }) {
    return ExamSession(
      id: id,
      status: status ?? this.status,
      baseDurationMinutes: baseDurationMinutes ?? this.baseDurationMinutes,
      startTime: startTime ?? this.startTime,
      globalPauseStartTime: globalPauseStartTime ?? this.globalPauseStartTime,
      totalGlobalPauseDuration:
          totalGlobalPauseDuration ?? this.totalGlobalPauseDuration,
      candidates: candidates ?? this.candidates,
    );
  }
}
