import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/candidate.dart';
import '../../../../data/models/exam_session.dart';
import '../../../../core/utils/time_utils.dart';
import '../../providers/session_provider.dart';

class CandidateCard extends ConsumerWidget {
  final Candidate candidate;
  final ExamSession session;

  const CandidateCard(
      {super.key, required this.candidate, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = candidate
            .calculateEndTime(session.currentGlobalOffset)
            ?.difference(DateTime.now()) ??
        Duration.zero;
    final isOnBreak = candidate.status == CandidateStatus.onBreak;
    final isFinished = candidate.status == CandidateStatus.finished;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isFinished
            ? Colors.black26
            : (isOnBreak
                ? Colors.amber.withOpacity(0.1)
                : const Color(0xFF1E293B)),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isFinished
                ? Colors.white10
                : (isOnBreak ? Colors.amber : Colors.white10)),
      ),
      child: Opacity(
        opacity: isFinished ? 0.5 : 1.0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    candidate.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (candidate.hasExtraTime)
                  const Badge(
                      label: Text("25% EXTRA"), backgroundColor: Colors.blue),
              ],
            ),
            const Divider(height: 20, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("REMAINING",
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                Text(
                  isFinished ? "FINISHED" : TimeUtils.formatDuration(remaining),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isFinished
                          ? Colors.white24
                          : (remaining.inMinutes < 5
                              ? Colors.red
                              : Colors.emerald)),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                if (candidate.breaksAllowed && !isFinished)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOnBreak ? Colors.amber : Colors.white12,
                        foregroundColor:
                            isOnBreak ? Colors.black : Colors.white,
                      ),
                      onPressed: () => ref
                          .read(sessionProvider.notifier)
                          .toggleCandidateBreak(candidate.id),
                      icon: Icon(isOnBreak ? Icons.play_arrow : Icons.pause),
                      label: Text(isOnBreak ? "RESUME" : "BREAK"),
                    ),
                  ),
                if (!isFinished) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white54),
                    onPressed: () => ref
                        .read(sessionProvider.notifier)
                        .finishCandidate(candidate.id),
                    tooltip: "Finish Candidate",
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
