import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../session/providers/session_provider.dart';
import '../../../data/models/exam_session.dart';
import '../../../data/models/candidate.dart';
import '../../../main.dart';
import './widgets/candidate_card.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final _nameController = TextEditingController();
  bool _hasExtraTime = false;
  bool _breaksAllowed = true;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final notifier = ref.read(sessionProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).state = 'menu',
        ),
        title: const Text("ADMIN DASHBOARD"),
        actions: [
          if (session.status != SessionStatus.idle) ...[
            IconButton(
              icon: Icon(session.status == SessionStatus.paused
                  ? Icons.play_arrow
                  : Icons.pause),
              color: Colors.amber,
              onPressed: () => notifier.toggleGlobalPause(),
              tooltip: "Fire Alarm Toggle",
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Quick way to reset during testing
                notifier.addCandidate(
                    "Resetting...", false, false); // Placeholder
              },
            ),
          ]
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(right: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("CANDIDATE SETUP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: 1.2)),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Candidate Name",
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                _buildToggle("25% Extra Time", _hasExtraTime,
                    (v) => setState(() => _hasExtraTime = v)),
                _buildToggle("Allow Breaks", _breaksAllowed,
                    (v) => setState(() => _breaksAllowed = v)),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      notifier.addCandidate(
                          _nameController.text, _hasExtraTime, _breaksAllowed);
                      _nameController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Text("ADD TO SESSION",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                if (session.status == SessionStatus.idle)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 64),
                      backgroundColor: Colors.emerald,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: session.candidates.isEmpty
                        ? null
                        : () => notifier.startExam(),
                    child: const Text("START EXAM",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CANDIDATES (${session.candidates.length})",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.black),
                      ),
                      if (session.status != SessionStatus.idle)
                        const Badge(
                          label: Text("LIVE"),
                          backgroundColor: Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: session.candidates.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.group_add,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.1)),
                                const SizedBox(height: 16),
                                const Text(
                                    "No candidates added to this session",
                                    style: TextStyle(color: Colors.white24)),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.6,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                            itemCount: session.candidates.length,
                            itemBuilder: (context, index) {
                              return CandidateCard(
                                candidate: session.candidates[index],
                                session: session,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label,
          style: const TextStyle(fontSize: 14, color: Colors.white70)),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }
}
