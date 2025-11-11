import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_service.dart';

class TestFirebaseScreen extends StatelessWidget {
  const TestFirebaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await FirebaseService.signUpWithEmail(
                    'test@example.com',
                    'password123'
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Success: ${result.user?.uid}'))
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'))
                  );
                }
              },
              child: const Text('Test Firebase Auth'),
            ),
          ],
        ),
      ),
    );
  }
}