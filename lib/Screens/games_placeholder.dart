import 'package:flutter/material.dart';

class GamesPlaceholder extends StatelessWidget {
  const GamesPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Games & AR')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videogame_asset, size: 72, color: Colors.green),
            const SizedBox(height: 12),
            const Text('Games & AR coming soon!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}
