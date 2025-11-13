import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/task.dart';
import '../Models/app_state.dart';
import '../services/tinydb_service.dart';
import '../services/auth_service.dart';
import 'add_child_screen.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Using a mock parent user ID for testing
  final String mockParentUserId = 'test_parent_123';
  
  // Mock data for testing
  List<Task> mockTasks = [
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchUserData() async {
    final userId = await TinyDB.getString('current_user');
    if (userId != null) {
      final usersJson = await TinyDB.getJson('users') ?? {};
      final userProfile = usersJson[userId];
      if (userProfile != null && mounted) {
        Provider.of<AppState>(context, listen: false).setEcoImpact(
          userProfile['ecoPoints'] ?? 0,
          userProfile['waterSaved'] ?? 0.0,
          userProfile['co2Saved'] ?? 0.0,
        );
      }
    }
  }

  Future<void> _approveTask(Task task) async {
    try {
      if (task.kidID == null) {
        throw Exception('Child ID not found for this task.');
      }
      // Update task status locally
      final tasks = await TinyDB.getJson('tasks') ?? {};
      if (tasks[task.id] != null) {
        tasks[task.id]['approvedByParent'] = true;
        tasks[task.id]['approvedAt'] = DateTime.now().toIso8601String();
        await TinyDB.setJson('tasks', tasks);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Approved! +${task.points} EcoPoints added to kid.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve task: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _rejectTask(Task task) async {
    String rejectReason = '';
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Task'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Reason for rejection'),
          onChanged: (value) => rejectReason = value,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (rejectReason.isNotEmpty) {
                try {
                  // Update task status locally
                  final tasks = await TinyDB.getJson('tasks') ?? {};
                  if (tasks[task.id] != null) {
                    tasks[task.id]['approvedByParent'] = false;
                    tasks[task.id]['rejectionReason'] = rejectReason;
                    await TinyDB.setJson('tasks', tasks);
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task rejected.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  Navigator.pop(ctx);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to reject task: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(Task task) async {
    try {
      // Delete task locally
      final tasks = await TinyDB.getJson('tasks') ?? {};
      tasks.remove(task.id);
      await TinyDB.setJson('tasks', tasks);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ Task "${task.title}" deleted.'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _addCustomTask() async {
    String title = '';
    String description = '';
    int points = 0;
    String? selectedKidId;
    List<String> linkedChildren = [];

    // Load linked children from SharedPreferences
  final linkedChildrenJson = await TinyDB.getString('linked_children');
    if (linkedChildrenJson != null && linkedChildrenJson.isNotEmpty) {
      linkedChildren = linkedChildrenJson.split(',');
    }

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => description = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Points'),
              keyboardType: TextInputType.number,
              onChanged: (value) => points = int.tryParse(value) ?? 0,
            ),
            if (linkedChildren.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Assign to Child'),
                items: linkedChildren.map((String username) {
                  return DropdownMenuItem<String>(
                    value: username,
                    child: Text(username),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedKidId = newValue;
                },
                validator: (value) => value == null ? 'Please select a child' : null,
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (title.isNotEmpty && description.isNotEmpty && points > 0 && selectedKidId != null) {
                try {
                  final parentId = await AuthService.getCurrentUserId();
                  if (parentId != null) {
                    // Create task locally
                    final tasks = await TinyDB.getJson('tasks') ?? {};
                    final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
                    tasks[taskId] = {
                      'id': taskId,
                      'title': title,
                      'description': description,
                      'points': points,
                      'kidID': selectedKidId,
                      'parentID': parentId,
                      'createdAt': DateTime.now().toIso8601String(),
                      'approvedByParent': false,
                      'isSubmitted': false,
                    };
                    await TinyDB.setJson('tasks', tasks);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ Task "$title" added for $selectedKidId!')),
                    );
                    Navigator.pop(ctx);
                  } else {
                    throw Exception('Parent not logged in.');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add task: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchRedeemURL() async {
    final Uri url = Uri.parse('https://www.loveable.com');
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url'), backgroundColor: Colors.red),
      );
    }
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

  void _linkGmailAccount() async {
    try {
      await AuthService.linkWithGoogle();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully linked with Google'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to link with Google: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard', style: GoogleFonts.poppins(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesome.google),
            tooltip: 'Link Gmail Account',
            onPressed: _linkGmailAccount,
          ),
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Link Children',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddChildScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              _showSignOutDialog(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Pending Approvals', icon: Icon(Icons.pending_actions)),
            Tab(text: 'Approved Tasks', icon: Icon(Icons.check_circle_outline)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isTabletOrDesktop ? 36 : 16, vertical: 12),
            child: Column(
              children: [
                _ImpactSummaryCard(
                  ecoPoints: appState.ecoPoints,
                  waterSaved: appState.waterSaved,
                  co2Saved: appState.co2Saved,
                  isLarge: isTabletOrDesktop,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _launchRedeemURL,
                        icon: const Icon(Icons.card_giftcard),
                        label: const Text('Redeem Rewards'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addCustomTask,
                        icon: const Icon(Icons.add_task),
                        label: const Text('Add Task'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF388E3C), foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(mockParentUserId, false), // Pending Approvals
                      _buildTaskList(mockParentUserId, true), // Approved Tasks
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(String parentId, bool approved) {
    return FutureBuilder<List<Task>>(
      future: _getTasksByApprovalStatus(approved),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final tasks = snapshot.data ?? [];
        if (tasks.isEmpty) {
          return Center(child: Text(approved ? 'No approved tasks.' : 'No pending tasks.'));
        }

        return ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _ParentTaskCard(
              task: task,
              onApprove: _approveTask,
              onReject: _rejectTask,
              onDelete: _deleteTask,
            );
          },
        );
      },
    );
  }

  Future<List<Task>> _getTasksByApprovalStatus(bool approved) async {
    try {
      final tasksMap = await TinyDB.getJson('tasks') ?? {};
      final allTasks = tasksMap.values
          .map((t) => Task.fromMap(t as Map<String, dynamic>))
          .toList();
      return allTasks.where((task) => task.approvedByParent == approved).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }
}

class _ImpactSummaryCard extends StatelessWidget {
  final int ecoPoints;
  final double waterSaved;
  final double co2Saved;
  final bool isLarge;

  const _ImpactSummaryCard({
    required this.ecoPoints,
    required this.waterSaved,
    required this.co2Saved,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(isLarge ? 32 : 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF80D8FF), Color(0xFF40C4FF)], // Soft Blue
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Family's Green Impact",
              style: GoogleFonts.poppins(
                fontSize: isLarge ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ImpactStat(icon: MaterialCommunityIcons.leaf, value: '$ecoPoints', label: 'EcoPoints', isLarge: isLarge),
                _ImpactStat(icon: MaterialCommunityIcons.water, value: '${waterSaved.toStringAsFixed(1)}L', label: 'Water Saved', isLarge: isLarge),
                _ImpactStat(icon: MaterialCommunityIcons.cloud_outline, value: '${co2Saved.toStringAsFixed(1)}kg', label: 'CO₂ Reduced', isLarge: isLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isLarge;

  const _ImpactStat({
    required this.icon,
    required this.value,
    required this.label,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: isLarge ? 40 : 32, color: Colors.white),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.poppins(fontSize: isLarge ? 24 : 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.poppins(fontSize: isLarge ? 14 : 12, color: Colors.white.withOpacity(0.9))),
      ],
    );
  }
}

class _ParentTaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) onApprove;
  final Function(Task) onReject;
  final Function(Task) onDelete;

  const _ParentTaskCard({
    required this.task,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(task.description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Points: ${task.points}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.green)),
            if (task.proofPhotoURL != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proof Photo:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    CachedNetworkImage(
                      imageUrl: task.proofPhotoURL!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            if (task.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Completed: ${task.completedAt!.toLocal().toString().split(' ')[0]}',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            if (!task.approvedByParent && task.completedAt != null) // Only show buttons for pending tasks
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => onApprove(task),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => onReject(task),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => onDelete(task),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

