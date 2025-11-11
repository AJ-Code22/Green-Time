import 'package:flutter/material.dart';
import 'task.dart';
import 'product.dart';

import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  String? _userId;
  int _ecoPoints = 0;
  List<Task> _tasks = [];
  List<Product> _purchasedItems = [];
  int _screenTimeMinutes = 0;
  double _waterSaved = 0;
  double _co2Saved = 0;

  String? get userId => _userId;
  int get ecoPoints => _ecoPoints;
  List<Task> get tasks => _tasks;
  List<Product> get purchasedItems => _purchasedItems;
  int get screenTimeMinutes => _screenTimeMinutes;
  double get waterSaved => _waterSaved;
  double get co2Saved => _co2Saved;

  void setUserId(String id) {
    _userId = id;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_userId == null) return;
    
    final userData = await FirebaseService.getUserProfile(_userId!);
    if (userData != null) {
      _ecoPoints = userData['ecoPoints'] ?? 0;
      _screenTimeMinutes = userData['screenTimeMinutes'] ?? 0;
      _waterSaved = (userData['waterSaved'] ?? 0).toDouble();
      _co2Saved = (userData['co2Saved'] ?? 0).toDouble();
      notifyListeners();
    }
  }

  Future<void> setEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints = points;
    await FirebaseService.updateUserPoints(_userId!, points);
    notifyListeners();
  }

  Future<void> addEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints += points;
    await FirebaseService.updateUserPoints(_userId!, points);
    notifyListeners();
  }

  Future<void> deductEcoPoints(int points) async {
    if (_userId == null) return;
    _ecoPoints -= points;
    await FirebaseService.updateUserPoints(_userId!, -points);
    notifyListeners();
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
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
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
    if (_userId == null) return;
    _screenTimeMinutes = minutes;
    await FirebaseService.updateGreenTime(_userId!, minutes);
    notifyListeners();
  }

  Future<void> addScreenTimeMinutes(int minutes) async {
    if (_userId == null) return;
    _screenTimeMinutes += minutes;
    await FirebaseService.updateGreenTime(_userId!, minutes);
    notifyListeners();
  }

  Future<void> setWaterSaved(double amount) async {
    if (_userId == null) return;
    _waterSaved = amount;
    await FirebaseService.updateEnvironmentalImpact(_userId!, amount, _co2Saved);
    notifyListeners();
  }

  Future<void> addWaterSaved(double amount) async {
    if (_userId == null) return;
    _waterSaved += amount;
    await FirebaseService.updateEnvironmentalImpact(_userId!, amount, 0);
    notifyListeners();
  }

  Future<void> setCo2Saved(double amount) async {
    if (_userId == null) return;
    _co2Saved = amount;
    await FirebaseService.updateEnvironmentalImpact(_userId!, _waterSaved, amount);
    notifyListeners();
  }

  Future<void> addCo2Saved(double amount) async {
    if (_userId == null) return;
    _co2Saved += amount;
    await FirebaseService.updateEnvironmentalImpact(_userId!, 0, amount);
    notifyListeners();
  }

  void resetState() {
    _ecoPoints = 0;
    _tasks = [];
    _purchasedItems = [];
    _screenTimeMinutes = 0;
    _waterSaved = 0;
    _co2Saved = 0;
    notifyListeners();
  }
}
