import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'services/firebase_service.dart';

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
                  // Firebase disabled for Windows
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Firebase not available on this platform'))
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