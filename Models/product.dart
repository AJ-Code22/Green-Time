class Product {
  final String id;
  final String name;
  final String description;
  final int points;
  final String type; // 'screenTime', 'toy', 'other'
  final String imageUrl;
  final String emoji;
  final double sustainabilityWeight;
  final int price;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.type,
    required this.imageUrl,
    required this.emoji,
    required this.sustainabilityWeight,
    required this.price,
  });

  int get finalPrice => (price * sustainabilityWeight).round();
}

// Mock products
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Reusable Bottle',
    description: 'Eco-friendly water bottle',
    points: 50,
    type: 'other',
    imageUrl: 'assets/images/bottle.png',
    emoji: '🍶',
    price: 100,
    sustainabilityWeight: 1.0,
  ),
  Product(
    id: '2',
    name: 'Gaming Headphones',
    description: 'Premium gaming headset',
    points: 200,
    type: 'toy',
    imageUrl: 'assets/images/headphones.png',
    emoji: '🎧',
    price: 100,
    sustainabilityWeight: 4.0,
  ),
  Product(
    id: '3',
    name: 'E-Book',
    description: 'Digital book voucher',
    points: 100,
    type: 'other',
    imageUrl: 'assets/images/ebook.png',
    emoji: '📚',
    price: 50,
    sustainabilityWeight: 2.0,
  ),
  Product(
    id: '4',
    name: 'Screen Time',
    description: '30 minutes of extra screen time',
    points: 50,
    type: 'screenTime',
    imageUrl: 'assets/images/screen_time.png',
    emoji: '⏰',
    price: 20,
    sustainabilityWeight: 2.5,
  ),
  Product(
    id: '5',
    name: 'Plant Kit',
    description: 'Grow your own herbs',
    points: 150,
    type: 'other',
    imageUrl: 'assets/images/plant_kit.png',
    emoji: '🌱',
    price: 80,
    sustainabilityWeight: 0.8,
  ),
];