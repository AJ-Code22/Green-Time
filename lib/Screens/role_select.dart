import 'package:flutter/material.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4CAF50),
              const Color(0xFF8BC34A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTabletOrDesktop ? 48 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌍', style: TextStyle(fontSize: isTabletOrDesktop ? 120 : 80)),
                  const SizedBox(height: 24),
                  Text(
                    'EcoMart Kids',
                    style: TextStyle(
                      fontSize: isTabletOrDesktop ? 48 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Save the planet, one task at a time!',
                    style: TextStyle(
                      fontSize: isTabletOrDesktop ? 20 : 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: isTabletOrDesktop ? 80 : 60),
                  _RoleCard(
                    title: 'I\'m a Kid! 👧👦',
                    description: 'Complete eco-tasks and earn points',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, '/child-dashboard');
                    },
                    isLarge: isTabletOrDesktop,
                  ),
                  const SizedBox(height: 24),
                  _RoleCard(
                    title: 'I\'m a Parent 👨‍👩‍👧',
                    description: 'Track progress and approve tasks',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pushNamed(context, '/parent-dashboard');
                    },
                    isLarge: isTabletOrDesktop,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool isLarge;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isLarge ? 500 : double.infinity,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(isLarge ? 32 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isLarge ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isLarge ? 18 : 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
