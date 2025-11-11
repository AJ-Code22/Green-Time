import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_screen.dart'; // We will create this new screen

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF80D8FF), // Soft Blue
              const Color(0xFFC8E6C9), // Soft Green
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
                  Text('🌿', style: TextStyle(fontSize: isTabletOrDesktop ? 100 : 80)),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to GreenTime',
                    style: GoogleFonts.poppins(
                      fontSize: isTabletOrDesktop ? 48 : 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004D40), // Dark Teal
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Save the planet, one task at a time!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isTabletOrDesktop ? 20 : 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: isTabletOrDesktop ? 80 : 60),
                  _RoleCard(
                    icon: MaterialCommunityIcons.human_child,
                    title: 'I\'m a Kid',
                    description: 'Complete tasks & earn rewards',
                    gradient: const LinearGradient(colors: [Color(0xFF29B6F6), Color(0xFF0288D1)]),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen(role: 'kid')));
                    },
                    isLarge: isTabletOrDesktop,
                  ),
                  const SizedBox(height: 24),
                  _RoleCard(
                    icon: MaterialCommunityIcons.human_male_female,
                    title: 'I\'m a Parent',
                    description: 'Manage tasks & approve rewards',
                    gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF388E3C)]),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen(role: 'parent')));
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
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;
  final bool isLarge;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
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
              borderRadius: BorderRadius.circular(20), // Match shape
              gradient: gradient,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: isLarge ? 50 : 40),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isLarge ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
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
