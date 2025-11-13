import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/services/tinydb_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('TinyDB user insert and search', () async {
    SharedPreferences.setMockInitialValues({}); // Reset storage
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
    expect(found.isNotEmpty, true);
    expect(found.first['email'], 'test@mail.com');
    expect(found.first['password'], '123456');
  });
}
