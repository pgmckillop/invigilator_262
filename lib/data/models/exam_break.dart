import 'package:hive/hive.dart';

part 'exam_break.g.dart';

@HiveType(typeId: 0)
class ExamBreak {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime? endTime;

  ExamBreak({
    required this.id,
    required this.startTime,
    this.endTime,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  ExamBreak copyWith({DateTime? endTime}) {
    return ExamBreak(
      id: id,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
