import 'package:flutter/material.dart';
import '../Models/task.dart';
import '../Models/app_state.dart';
import 'redeem_screen.dart';
import '../services/shared_prefs_service.dart';

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
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final newLimit = await showDialog<int>(
                context: context,
                builder: (ctx) {
                  int tmp = SharedPrefsService.dailyLimit;
                  return AlertDialog(
                    title: const Text('Set daily screen time limit (minutes)'),
                    content: StatefulBuilder(builder: (c, setSt) {
                      return Slider(
                        min: 0,
                        max: 240,
                        divisions: 24,
                        label: '$tmp',
                        value: tmp.toDouble(),
                        onChanged: (v) => setSt(() => tmp = v.round()),
                      );
                    }),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, tmp), child: const Text('Save')),
                    ],
                  );
                },
              );
              if (newLimit != null) {
                await SharedPrefsService.setDailyLimit(newLimit);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily limit saved')));
                setState(() {});
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTabletOrDesktop ? 28 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImpactCard(
              ecoPoints: AppState.ecoPoints.toInt(),
              waterSaved: AppState.waterSaved,
              co2Saved: AppState.co2Saved,
              isLarge: isTabletOrDesktop,
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/redeem').then((_) => setState(() {})),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Redeem'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progress reset')));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              )
            ]),
            const SizedBox(height: 18),
            Text('Pending Approvals (${pendingTasks.length})', style: TextStyle(fontSize: isTabletOrDesktop ? 24 : 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (pendingTasks.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('No pending tasks', style: TextStyle(color: Colors.black54)), const SizedBox(height: 8), Text('Daily limit: ${SharedPrefsService.dailyLimit} min')]),
                ),
              )
            else
              ...pendingTasks.map((task) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(backgroundColor: Colors.green.shade100, child: const Icon(Icons.pending, color: Colors.green)),
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(task.description), const SizedBox(height: 6), Text('+${task.points} GreenTime', style: const TextStyle(color: Colors.green))]),
                      trailing: ElevatedButton(onPressed: () => _approveTask(task), child: const Text('Approve')),
                    ),
                  )),
          ],
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
