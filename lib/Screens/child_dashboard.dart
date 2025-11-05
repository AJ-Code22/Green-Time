import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../Models/task.dart';
import '../Models/app_state.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({Key? key}) : super(key: key);

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _completeTask(Task task) {
    if (!task.isCompleted) {
      setState(() {
        task.isCompleted = true;
      });
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Good job! Waiting for parent verification...'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    int pendingPoints = AppState.tasks.where((t) => t.isCompleted && !t.isApproved).fold(0, (sum, task) => sum + task.points);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Missions 🌱'),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/redeem'),
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Redeem'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTabletOrDesktop ? 36 : 16, vertical: 12),
        child: Column(
          children: [
            if (pendingPoints > 0)
              Card(
                color: Colors.amber.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pending approval: $pendingPoints GreenTime', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/parent-dashboard'), child: const Text('Ask parent'))
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: AppState.tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final task = AppState.tasks[index];
                  return _TaskCard(task: task, onCompleted: () => _completeTask(task));
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/games'),
                    icon: const Icon(Icons.videogame_asset),
                    label: const Text('Play mini-games'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scan proof placeholder'))),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan / Proof'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onCompleted;

  const _TaskCard({required this.task, required this.onCompleted, Key? key}) : super(key: key);

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _markDone() {
    if (!widget.task.isCompleted) {
      setState(() {
        widget.task.isCompleted = true;
      });
      _confettiController.play();
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: Colors.green.shade50, child: const Icon(Icons.eco, color: Colors.green)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(widget.task.description, style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Row(children: [const Icon(Icons.timer, size: 14, color: Colors.grey), const SizedBox(width: 6), Text('${widget.task.points} GreenTime', style: const TextStyle(color: Colors.green))]),
                    ],
                  ),
                ),
                widget.task.isCompleted
                    ? Chip(label: const Text('Pending'))
                    : ElevatedButton(onPressed: _markDone, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Done'))
              ],
            ),
          ),
        ),
        Positioned(top: -6, left: 8, child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false, colors: const [Colors.green, Colors.blue, Colors.orange]))
      ],
    );
  }
}