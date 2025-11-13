import 'dart:async';
import 'package:flutter/material.dart';
import 'task.dart';
import 'product.dart';
import '../services/tinydb_service.dart';

class AppState extends ChangeNotifier {
  String? _userId;
  String? _userRole; // 'parent' or 'child'
  String? _username; // child's username or parent's name

  int _ecoPoints = 0;
  List<Task> _tasks = [];
  List<Product> _purchasedItems = [];
  int _screenTimeMinutes = 0;
  double _waterSaved = 0;
  double _co2Saved = 0;

  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get username => _username;
  int get ecoPoints => _ecoPoints;
  List<Task> get tasks => _tasks;
  List<Product> get purchasedItems => _purchasedItems;
  int get screenTimeMinutes => _screenTimeMinutes;
  double get waterSaved => _waterSaved;
  double get co2Saved => _co2Saved;

  void setUserId(String id, {String? role, String? username}) {
    _userId = id;
    _userRole = role;
    _username = username;
    _loadUserProfile(id);
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final userData = await TinyDB.getJson('users');
      if (userData != null && userData.containsKey(userId)) {
        final profile = userData[userId] as Map<String, dynamic>;
        _ecoPoints = profile['ecoPoints'] ?? 0;
        _screenTimeMinutes = profile['screenTimeMinutes'] ?? 0;
        _waterSaved = (profile['waterSaved'] ?? 0).toDouble();
        _co2Saved = (profile['co2Saved'] ?? 0).toDouble();
        _userRole = profile['role'];
        _username = profile['username'] ?? profile['displayName'];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> setEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints = points;
    notifyListeners();
    await _updateUserProfile({'ecoPoints': points});
  }

  Future<void> addEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints += points;
    notifyListeners();
    await _updateUserProfile({'ecoPoints': _ecoPoints});
  }

  Future<void> deductEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints = (_ecoPoints - points).clamp(0, double.maxFinite).toInt();
    notifyListeners();
    await _updateUserProfile({'ecoPoints': _ecoPoints});
  }

  Future<void> setEcoImpact(int points, double water, double co2) async {
    _ecoPoints = points;
    _waterSaved = water;
    _co2Saved = co2;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({
        'ecoPoints': points,
        'waterSaved': water,
        'co2Saved': co2,
      });
    }
  }

  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void setPurchasedItems(List<Product> items) {
    _purchasedItems = items;
    notifyListeners();
  }

  void addPurchasedItem(Product item) {
    _purchasedItems.add(item);
    notifyListeners();
  }

  Future<void> setScreenTimeMinutes(int minutes) async {
    _screenTimeMinutes = minutes;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'screenTimeMinutes': minutes});
    }
  }

  Future<void> addScreenTimeMinutes(int minutes) async {
    _screenTimeMinutes += minutes;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'screenTimeMinutes': _screenTimeMinutes});
    }
  }

  Future<void> setWaterSaved(double amount) async {
    _waterSaved = amount;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'waterSaved': amount});
    }
  }

  Future<void> addWaterSaved(double amount) async {
    _waterSaved += amount;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'waterSaved': _waterSaved});
    }
  }

  Future<void> setCo2Saved(double amount) async {
    _co2Saved = amount;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'co2Saved': amount});
    }
  }

  Future<void> addCo2Saved(double amount) async {
    _co2Saved += amount;
    notifyListeners();
    if (_userId != null) {
      await _updateUserProfile({'co2Saved': _co2Saved});
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> updates) async {
    if (_userId == null) return;
    try {
      final users = await TinyDB.getJson('users') ?? {};
      if (users.containsKey(_userId)) {
        users[_userId].addAll(updates);
        await TinyDB.setJson('users', users);
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  void resetState() {
    _userId = null;
    _userRole = null;
    _username = null;
    _ecoPoints = 0;
    _tasks = [];
    _purchasedItems = [];
    _screenTimeMinutes = 0;
    _waterSaved = 0;
    _co2Saved = 0;
    notifyListeners();
  }
}
