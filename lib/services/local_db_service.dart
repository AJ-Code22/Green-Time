import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalDBService {
  static const String _usersBox = 'users';
  static const String _tasksBox = 'tasks';
  static const String _settingsBox = 'settings';
  
  static Future<void> initialize() async {
    // Initialize Hive and set up the application documents directory
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Open boxes (similar to TinyDB tables)
    await Hive.openBox(_usersBox);
    await Hive.openBox(_tasksBox);
    await Hive.openBox(_settingsBox);
  }

  // User Authentication Methods
  static Future<bool> createUser(String loginId, String password, Map<String, dynamic> userData) async {
    try {
      final usersBox = Hive.box(_usersBox);
      // Check if user already exists
      if (usersBox.get(loginId) != null) {
        return false;
      }
      
      // Store user data with password
      await usersBox.put(loginId, {
        ...userData,
        'password': password,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> verifyLogin(String loginId, String password) async {
    try {
      final usersBox = Hive.box(_usersBox);
      final userData = usersBox.get(loginId);
      
      if (userData != null && userData['password'] == password) {
        // Return user data without password
        final Map<String, dynamic> userInfo = Map.from(userData);
        userInfo.remove('password');
        return userInfo;
      }
      return null;
    } catch (e) {
      print('Error verifying login: $e');
      return null;
    }
  }

  // Task Management Methods
  static Future<String?> createTask(Map<String, dynamic> taskData) async {
    try {
      final tasksBox = Hive.box(_tasksBox);
      final taskId = DateTime.now().millisecondsSinceEpoch.toString();
      await tasksBox.put(taskId, {
        ...taskData,
        'created_at': DateTime.now().toIso8601String(),
      });
      return taskId;
    } catch (e) {
      print('Error creating task: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserTasks(String userId) async {
    try {
      final tasksBox = Hive.box(_tasksBox);
      final List<Map<String, dynamic>> userTasks = [];
      
      for (var key in tasksBox.keys) {
        final task = tasksBox.get(key);
        if (task['userId'] == userId) {
          userTasks.add({...task, 'id': key});
        }
      }
      
      return userTasks;
    } catch (e) {
      print('Error getting user tasks: $e');
      return [];
    }
  }

  static Future<bool> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      final tasksBox = Hive.box(_tasksBox);
      final task = tasksBox.get(taskId);
      
      if (task != null) {
        await tasksBox.put(taskId, {
          ...task,
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  // User Profile Methods
  static Future<bool> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final usersBox = Hive.box(_usersBox);
      final userData = usersBox.get(userId);
      
      if (userData != null) {
        await usersBox.put(userId, {
          ...userData,
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Settings Methods
  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      final settingsBox = Hive.box(_settingsBox);
      await settingsBox.put(key, value);
    } catch (e) {
      print('Error saving setting: $e');
    }
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    try {
      final settingsBox = Hive.box(_settingsBox);
      return settingsBox.get(key, defaultValue: defaultValue);
    } catch (e) {
      print('Error getting setting: $e');
      return defaultValue;
    }
  }
}