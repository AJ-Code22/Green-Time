class User {
  final String id;
  final String name;
  final String username;
  final String role; // 'child' or 'parent'
  int ecoPoints;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    this.ecoPoints = 0,
  });
}
