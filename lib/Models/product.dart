import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final double sustainabilityWeight;
  final String emoji;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.sustainabilityWeight,
    required this.emoji,
  });

  int get finalPrice => (price * sustainabilityWeight).round();

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Product(
      id: snapshot.id,
      name: data?['name'],
      description: data?['description'],
      price: data?['price'],
      sustainabilityWeight: data?['sustainabilityWeight'],
      emoji: data?['emoji'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'sustainabilityWeight': sustainabilityWeight,
      'emoji': emoji,
    };
  }
}
