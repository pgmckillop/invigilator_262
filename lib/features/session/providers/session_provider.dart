import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/exam_session.dart';
import '../../../data/models/candidate.dart';
import '../../../data/models/exam_break.dart';

final sessionProvider = NotifierProvider<SessionNotifier, ExamSession>(() {
  return SessionNotifier();
});

class SessionNotifier extends Notifier<ExamSession> {
  static const String _boxName = 'session_box';
  late Box<ExamSession> _box;

  @override
  ExamSession build() {
    _box = Hive.box<ExamSession>(_boxName);
    // Return existing session or a fresh one
    return _box.get('current') ??
        ExamSession(id: 'default', baseDurationMinutes: 60);
  }

  void _persist() {
    _box.put('current', state);
  }

  void startExam() {
    final now = DateTime.now();
    state = state.copyWith(
      status: SessionStatus.running,
      startTime: now,
      candidates: state.candidates
          .map(
              (c) => c.copyWith(startTime: now, status: CandidateStatus.active))
          .toList(),
    );
    _persist();
  }

  void toggleGlobalPause() {
    final now = DateTime.now();
    if (state.status == SessionStatus.running) {
      state = state.copyWith(
        status: SessionStatus.paused,
        globalPauseStartTime: now,
      );
    } else if (state.status == SessionStatus.paused) {
      final pauseDuration = now.difference(state.globalPauseStartTime!);
      state = state.copyWith(
        status: SessionStatus.running,
        globalPauseStartTime: null,
        totalGlobalPauseDuration:
            state.totalGlobalPauseDuration + pauseDuration,
      );
    }
    _persist();
  }

  void addCandidate(String name, bool hasExtraTime, bool breaksAllowed) {
    final candidate = Candidate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      hasExtraTime: hasExtraTime,
      breaksAllowed: breaksAllowed,
      baseDurationMinutes: state.baseDurationMinutes,
      startTime: state.startTime,
    );
    state = state.copyWith(candidates: [...state.candidates, candidate]);
    _persist();
  }

  void toggleCandidateBreak(String id) {
    final now = DateTime.now();
    final candidates = state.candidates.map((c) {
      if (c.id != id) return c;

      if (c.status == CandidateStatus.active) {
        final newBreak = ExamBreak(id: now.toIso8601String(), startTime: now);
        return c.copyWith(
          status: CandidateStatus.onBreak,
          breaks: [...c.breaks, newBreak],
        );
      } else if (c.status == CandidateStatus.onBreak) {
        final lastBreak = c.breaks.last.copyWith(endTime: now);
        final updatedBreaks = [
          ...c.breaks.sublist(0, c.breaks.length - 1),
          lastBreak
        ];
        return c.copyWith(
          status: CandidateStatus.active,
          breaks: updatedBreaks,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(candidates: candidates);
    _persist();
  }
}
