import 'package:flutter/material.dart';
import '../Models/task.dart';
import '../Models/app_state.dart';
import '../lib/Screens/redeem_screen.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  void _approveTask(Task task) {
    setState(() {
      task.isApproved = true;
      AppState.ecoPoints += task.points;
      AppState.waterSaved += task.points * 0.5;
      AppState.co2Saved += task.points * 0.3;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Approved! +${task.points} EcoPoints added'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    final pendingTasks = AppState.tasks.where((t) => t.isCompleted && !t.isApproved).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard 👨‍👩‍👧'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTabletOrDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isTabletOrDesktop ? 1000 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ImpactCard(
                                        ecoPoints: AppState.ecoPoints.toInt(),
                  waterSaved: AppState.waterSaved,
                  co2Saved: AppState.co2Saved,
                  isLarge: isTabletOrDesktop,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RedeemScreen(isParent: true),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        icon: const Icon(Icons.card_giftcard),
                        label: Text('Redeem Rewards', style: TextStyle(fontSize: isTabletOrDesktop ? 18 : 14)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(isTabletOrDesktop ? 20 : 16),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            AppState.tasks = List.from(sampleTasks);
                            AppState.ecoPoints = 0;
                            AppState.purchasedItems.clear();
                            AppState.waterSaved = 0;
                            AppState.co2Saved = 0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🔄 Progress reset!')),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text('Reset', style: TextStyle(fontSize: isTabletOrDesktop ? 18 : 14)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(isTabletOrDesktop ? 20 : 16),
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Pending Approvals (${pendingTasks.length})',
                  style: TextStyle(fontSize: isTabletOrDesktop ? 28 : 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (pendingTasks.isEmpty)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(isTabletOrDesktop ? 48 : 32),
                      child: Column(
                        children: [
                          Text('✨', style: TextStyle(fontSize: isTabletOrDesktop ? 60 : 48)),
                          const SizedBox(height: 16),
                          Text('No pending tasks', style: TextStyle(fontSize: isTabletOrDesktop ? 20 : 18, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  )
                else
                  ...pendingTasks.map((task) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(isTabletOrDesktop ? 20 : 16),
                          leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.pending, color: Colors.white)),
                          title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTabletOrDesktop ? 20 : 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(task.description, style: TextStyle(fontSize: isTabletOrDesktop ? 16 : 14)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: isTabletOrDesktop ? 20 : 16),
                                  const SizedBox(width: 4),
                                  Text('+${task.points} points', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[700], fontSize: isTabletOrDesktop ? 16 : 14)),
                                ],
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _approveTask(task),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Approve'),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final int ecoPoints;
  final double waterSaved;
  final double co2Saved;
  final bool isLarge;

  const _ImpactCard({required this.ecoPoints, required this.waterSaved, required this.co2Saved, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(isLarge ? 32 : 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Colors.purple, Color(0xFF9C27B0)])),
        child: Column(
          children: [
            Text('Sustainability Impact', style: TextStyle(fontSize: isLarge ? 28 : 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ImpactStat(icon: '🌟', value: '$ecoPoints', label: 'EcoPoints', isLarge: isLarge),
                _ImpactStat(icon: '💧', value: '${waterSaved.toStringAsFixed(1)}L', label: 'Water Saved', isLarge: isLarge),
                _ImpactStat(icon: '🌍', value: '${co2Saved.toStringAsFixed(1)}kg', label: 'CO₂ Reduced', isLarge: isLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final bool isLarge;

  const _ImpactStat({required this.icon, required this.value, required this.label, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: isLarge ? 40 : 32)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: isLarge ? 24 : 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: isLarge ? 14 : 12, color: Colors.white.withOpacity(0.9))),
      ],
    );
  }
}
