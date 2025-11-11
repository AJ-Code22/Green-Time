import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  static FirebaseFirestore get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      print('Firestore not available on this platform: $e');
      rethrow;
    }
  }
  
  static FirebaseStorage get _storage {
    try {
      return FirebaseStorage.instance;
    } catch (e) {
      print('Firebase Storage not available on this platform: $e');
      rethrow;
    }
  }

  // User profile methods
  static Future<void> createUserProfile(String userId, String name, String role) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'role': role,
      'ecoPoints': 0,
      'greenTime': 0,
      'screenTimeMinutes': 0,
      'waterSaved': 0.0,
      'co2Saved': 0.0,
      'tasksCompleted': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  // Task methods
  static Future<String> createTask(Map<String, dynamic> taskData) async {
    final docRef = await _firestore.collection('tasks').add({
      ...taskData,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  static Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    await _firestore.collection('tasks').doc(taskId).update(updates);
  }

  static Stream<QuerySnapshot> getTasksStream(String kidId) {
    return _firestore
        .collection('tasks')
        .where('kidId', isEqualTo: kidId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Storage methods
  static Future<String> uploadTaskProof(String taskId, File imageFile) async {
    final ref = _storage.ref().child('task_proofs/$taskId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Points and rewards methods
  static Future<void> updateUserPoints(String userId, int points) async {
    await _firestore.collection('users').doc(userId).update({
      'ecoPoints': FieldValue.increment(points),
      'tasksCompleted': FieldValue.increment(1),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateGreenTime(String userId, int minutes) async {
    await _firestore.collection('users').doc(userId).update({
      'greenTime': FieldValue.increment(minutes),
      'screenTimeMinutes': FieldValue.increment(minutes),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateEnvironmentalImpact(String userId, double water, double co2) async {
    await _firestore.collection('users').doc(userId).update({
      'waterSaved': FieldValue.increment(water),
      'co2Saved': FieldValue.increment(co2),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Product purchase methods
  static Future<void> purchaseProduct(String userId, String productId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final purchaseDoc = _firestore.collection('purchases').doc();
    
    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userDoc);
      final userData = userSnapshot.data()!;
      final currentPoints = userData['ecoPoints'] as int;
      final productSnapshot = await transaction.get(_firestore.collection('products').doc(productId));
      final productData = productSnapshot.data()!;
      final cost = productData['cost'] as int;

      if (currentPoints >= cost) {
        transaction.update(userDoc, {
          'ecoPoints': currentPoints - cost,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        transaction.set(purchaseDoc, {
          'userId': userId,
          'productId': productId,
          'cost': cost,
          'purchasedAt': FieldValue.serverTimestamp(),
          'status': 'completed'
        });
      } else {
        throw Exception('Insufficient points');
      }
    });
  }

  static Stream<QuerySnapshot> getPurchasesStream(String userId) {
    return _firestore
        .collection('purchases')
        .where('userId', isEqualTo: userId)
        .orderBy('purchasedAt', descending: true)
        .snapshots();
  }

  // Parent control methods
  static Future<void> setDailyLimit(String kidId, int minutes) async {
    await _firestore.collection('users').doc(kidId).update({
      'dailyScreenTimeLimit': minutes,
    });
  }

  static Future<void> approveTask(String taskId, int points) async {
    final task = await _firestore.collection('tasks').doc(taskId).get();
    final kidId = task.data()?['kidId'];
    
    await Future.wait([
      updateTask(taskId, {'approved': true, 'approvedAt': FieldValue.serverTimestamp()}),
      updateUserPoints(kidId, points),
    ]);
  }
}