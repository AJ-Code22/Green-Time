import 'package:flutter/material.dart';
import 'task.dart';
import 'product.dart';

class AppState extends ChangeNotifier {
  double _ecoPoints = 0;
  double get ecoPoints => _ecoPoints;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Other state variables can be added here

  void setEcoPoints(double points) {
    _ecoPoints = points;
    notifyListeners();
  }

  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }
}
