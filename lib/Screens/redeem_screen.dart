import 'package:flutter/material.dart';
import '../Models/product.dart';
import '../Models/app_state.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  void _redeemProduct(Product product) {
    final cost = product.finalPrice;
    if (AppState.ecoPoints >= cost) {
      setState(() {
        AppState.ecoPoints -= cost;
        AppState.purchasedItems.add(product);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Redeemed ${product.name}!'), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Need ${cost - AppState.ecoPoints} more points.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLarge = size.width > 600;
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem Rewards')),
      body: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 12),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isLarge ? 3 : 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: mockProducts.length,
          itemBuilder: (context, index) {
            final p = mockProducts[index];
            final affordable = AppState.ecoPoints >= p.finalPrice;
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(p.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(p.description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: affordable ? () => _redeemProduct(p) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: affordable ? Colors.orange : Colors.grey),
                      child: Text('${p.finalPrice} pts'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
