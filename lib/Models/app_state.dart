import 'task.dart';
import 'product.dart';

class AppState {
  static int ecoPoints = 0;
  static List<Task> tasks = List.from(sampleTasks);
  static List<Product> purchasedItems = [];
  static int screenTimeMinutes = 0;
  static double waterSaved = 0;
  static double co2Saved = 0;
}
