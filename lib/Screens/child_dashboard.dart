import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:hi/services/auth_service.dart';
import 'package:hi/services/tinydb_service.dart';
import '../Models/task.dart';
import '../Models/app_state.dart';
import 'role_select.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({Key? key}) : super(key: key);

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  late ConfettiController _confettiController;
  bool _isLoading = false;
  
  // Mock data for testing
  int ecoPoints = 250;
  int greenTime = 1240;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  Future<void> _fetchUserData() async {
    final userId = await TinyDB.getString('current_user');
    if (userId != null) {
      final usersJson = await TinyDB.getJson('users') ?? {};
      final userProfile = usersJson[userId];
      if (userProfile != null && mounted) {
        setState(() {
          ecoPoints = userProfile['ecoPoints'] ?? 0;
          greenTime = userProfile['greenTime'] ?? 0;
        });
      }
    }
  }

  Future<void> _markTaskDone(Task task) async {
    setState(() => _isLoading = true);
    try {
      // Mark task as completed locally
      final tasks = await TinyDB.getJson('tasks') ?? {};
      if (tasks[task.id] != null) {
        tasks[task.id]['completedAt'] = DateTime.now().toIso8601String();
        tasks[task.id]['status'] = 'completed';
        await TinyDB.setJson('tasks', tasks);
      }

      _confettiController.play();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Task completed!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete task: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await AuthService.signOut();
              
              // Sign out from AppState
              if (mounted) {
                Provider.of<AppState>(context, listen: false).resetState();
                Navigator.pop(ctx);
                // Navigate back to role select
                Navigator.pushNamedAndRemoveUntil(context, '/role-select', (route) => false);
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;
    
    // Mock tasks for testing
    final mockTaskList = [
      Task(
        id: '1',
        title: 'Plant a Tree',
        description: 'Plant one tree in your area',
        points: 50,
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Recycle Paper',
        description: 'Recycle a kg of paper',
        points: 20,
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Missions 🌱',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF1F8E9), Color(0xFFE8F5E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTabletOrDesktop ? 36 : 16,
                vertical: 12,
              ),
              child: Column(
                children: [
                  _buildPointsAndScreenTime(
                    appState.ecoPoints,
                    appState.screenTimeMinutes,
                    isTabletOrDesktop,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: _getTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.eco_outlined,
                                  size: 64,
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tasks assigned yet!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final tasks = (snapshot.data!['tasks'] as List<dynamic>? ?? []).cast<Task>();

                        return tasks.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.eco_outlined,
                                      size: 64,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No tasks assigned yet!',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: tasks.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return _TaskCard(
                                    task: task,
                                    onMarkDone: _markTaskDone,
                                    isLoading: _isLoading,
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink,
                  Colors.purple,
                ],
                numberOfParticles: 20,
                emissionFrequency: 0.05,
                maxBlastForce: 100,
                minBlastForce: 80,
                gravity: 0.3,
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPointsAndScreenTime(
      int ecoPoints, int screenTimeMinutes, bool isLarge) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCircularProgress(
              'Eco Points',
              ecoPoints,
              Colors.green,
              isLarge,
            ),
            _buildCircularProgress(
              'GreenTime',
              screenTimeMinutes,
              Colors.blue,
              isLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(
      String label, int value, Color color, bool isLarge) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: isLarge ? 100 : 80,
              height: isLarge ? 100 : 80,
              child: CircularProgressIndicator(
                value: value / 100.0,
                strokeWidth: 8,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '$value',
              style: GoogleFonts.poppins(
                fontSize: isLarge ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isLarge ? 16 : 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>?> _getTasks() async {
    try {
      final tasks = await TinyDB.getJson('tasks') ?? {};
      return {'tasks': (tasks.values.toList() as List<dynamic>).map((t) => Task.fromMap(t as Map<String, dynamic>)).toList()};
    } catch (e) {
      print('Error fetching tasks: $e');
      return null;
    }
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) onMarkDone;
  final bool isLoading;

  const _TaskCard({
    required this.task,
    required this.onMarkDone,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  task.approvedByParent ? Colors.green.shade100 : Colors.orange.shade100,
              child: Icon(
                task.approvedByParent
                    ? Icons.check_circle_outline
                    : Icons.pending_actions,
                color: task.approvedByParent ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        MaterialCommunityIcons.leaf,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${task.points} EcoPoints',
                        style: GoogleFonts.poppins(color: Colors.green),
                      ),
                    ],
                  ),
                  if (task.proofPhotoURL != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          task.proofPhotoURL!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildTaskActionButton(task, onMarkDone),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskActionButton(Task task, Function(Task) onMarkDone) {
    if (task.completedAt != null && !task.approvedByParent) {
      return Chip(
        label: Text(
          'Pending',
          style: GoogleFonts.poppins(color: Colors.orange),
        ),
        backgroundColor: Colors.orange.shade50,
      );
    } else if (task.approvedByParent) {
      return Chip(
        label: Text(
          'Approved',
          style: GoogleFonts.poppins(color: Colors.green),
        ),
        backgroundColor: Colors.green.shade50,
      );
    } else {
      return ElevatedButton(
        onPressed: isLoading ? null : () => onMarkDone(task),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: Text(
          'Mark Done',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      );
    }
  }
}

