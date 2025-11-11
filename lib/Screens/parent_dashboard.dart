import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/task.dart';
import '../Models/app_state.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with SingleTickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  // Using a mock parent user ID for testing
  final String mockParentUserId = 'test_parent_123';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _firestore.collection('users').doc(mockParentUserId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          Provider.of<AppState>(context, listen: false).setEcoPoints(data['ecoPoints'] ?? 0);
          Provider.of<AppState>(context, listen: false).setWaterSaved(data['waterSaved']?.toDouble() ?? 0.0);
          Provider.of<AppState>(context, listen: false).setCo2Saved(data['co2Saved']?.toDouble() ?? 0.0);
        }
      }
    });
  }

  Future<void> _approveTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update({
        'approvedByParent': true,
      });

      // Update kid's ecoPoints, waterSaved, co2Saved
      await _firestore.collection('users').doc(task.kidID).update({
        'ecoPoints': FieldValue.increment(task.points),
        'waterSaved': FieldValue.increment(task.points * 0.5), // Example calculation
        'co2Saved': FieldValue.increment(task.points * 0.3), // Example calculation
      });

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
    try {
      await _firestore.collection('tasks').doc(task.id).update({
        'proofPhotoURL': FieldValue.delete(),
        'completedAt': FieldValue.delete(),
        'approvedByParent': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Task rejected. Proof removed.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject task: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _addCustomTask() async {
    String title = '';
    String description = '';
    int points = 0;
    String kidId = ''; // This needs to be selected from available kids

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
            // TODO: Implement kid selection dropdown
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (title.isNotEmpty && description.isNotEmpty && points > 0 && kidId.isNotEmpty) {
                await _firestore.collection('tasks').add({
                  'title': title,
                  'description': description,
                  'points': points,
                  'kidID': kidId,
                  'approvedByParent': false,
                  'proofPhotoURL': null,
                  'completedAt': null,
                });
                Navigator.pop(ctx);
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
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('tasks').where('approvedByParent', isEqualTo: approved).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(approved ? 'No approved tasks.' : 'No pending tasks.'));
        }

        final tasks = snapshot.data!.docs.map((doc) => Task.fromFirestore(doc)).toList();

        return ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _ParentTaskCard(
              task: task,
              onApprove: _approveTask,
              onReject: _rejectTask,
            );
          },
        );
      },
    );
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

  const _ParentTaskCard({
    required this.task,
    required this.onApprove,
    required this.onReject,
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
                    Image.network(task.proofPhotoURL!, height: 100, width: 100, fit: BoxFit.cover),
                  ],
                ),
              ),
            if (task.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Completed: ${task.completedAt!.toDate().toLocal().toString().split(' ')[0]}',
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

