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
