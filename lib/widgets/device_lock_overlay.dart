import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/device_lock_service.dart';

class DeviceLockOverlay extends StatelessWidget {
  final String childUserId;
  final Widget child;

  const DeviceLockOverlay({
    Key? key,
    required this.childUserId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: DeviceLockService.watchDeviceLock(childUserId),
      builder: (context, snapshot) {
        final isLocked = snapshot.data ?? false;

        if (isLocked) {
          return Stack(
            children: [
              child,
              // Full-screen lock overlay
              Container(
                color: Colors.black.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 120,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Device Locked',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This device has been locked by your parent.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '⏰ Please ask your parent to unlock it.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
