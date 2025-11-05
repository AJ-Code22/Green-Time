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
}

// Mock products
final List<Product> mockProducts = [
  Product(id: '1', name: 'Reusable Bottle', description: 'Eco-friendly water bottle', price: 100, sustainabilityWeight: 1.0, emoji: '🍶'),
  Product(id: '2', name: 'Gaming Headphones', description: 'Premium gaming headset', price: 100, sustainabilityWeight: 4.0, emoji: '🎧'),
  Product(id: '3', name: 'E-Book', description: 'Digital book voucher', price: 50, sustainabilityWeight: 2.0, emoji: '📚'),
  Product(id: '4', name: 'Screen Time', description: '30 minutes of extra screen time', price: 20, sustainabilityWeight: 2.5, emoji: '⏰'),
  Product(id: '5', name: 'Plant Kit', description: 'Grow your own herbs', price: 80, sustainabilityWeight: 0.8, emoji: '🌱'),
];
