import 'services/tinydb_service.dart';

Future<void> testTinyDBUser() async {
  // Insert a user
  final users = await TinyDB.getJson('users') ?? {};
  users['test@mail.com'] = {
    'username': 'testuser',
    'email': 'test@mail.com',
    'password': '123456'
  };
  await TinyDB.setJson('users', users);

  // Search for a user by username
  final found = users.values.where((u) => u['username'] == 'testuser').toList();
  print(found); // Should print user info if found
}

void main() async {
  await testTinyDBUser();
}
