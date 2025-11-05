import 'package:flutter/material.dart';
import '../Models/task.dart';
import '../Models/app_state.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({Key? key}) : super(key: key);

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _completeTask(Task task) {
    if (!task.isCompleted) {
      setState(() {
        task.isCompleted = true;
      });
      _animationController.forward().then((_) => _animationController.reverse());
      _showConfetti();
    }
  }

  void _showConfetti() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Text('🎉 Task completed! '),
            Text('Waiting for parent approval...'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    int pendingPoints = AppState.tasks
        .where((t) => t.isCompleted && !t.isApproved)
        .fold(0, (sum, task) => sum + task.points);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Eco Tasks 🌱'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (pendingPoints > 0)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.amber.shade100,
              child: Text(
                'You have $pendingPoints points pending approval!',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isTabletOrDesktop ? 48.0 : 16.0,
              ),
              itemCount: AppState.tasks.length,
              itemBuilder: (context, index) {
                final task = AppState.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('${task.points} points'),
                  trailing: IconButton(
                    icon: Icon(
                      task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => _completeTask(task),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}