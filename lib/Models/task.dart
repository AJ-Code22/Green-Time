import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final int points;
  final String? proofPhotoURL;
  final bool approvedByParent;
  final Timestamp? completedAt;
  final String kidID;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.proofPhotoURL,
    this.approvedByParent = false,
    this.completedAt,
    required this.kidID,
  });

  factory Task.fromFirestore(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data was null');
    }
    return Task(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      proofPhotoURL: data['proofPhotoURL'],
      approvedByParent: data['approvedByParent'] ?? false,
      completedAt: data['completedAt'],
      kidID: data['kidID'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'points': points,
      'proofPhotoURL': proofPhotoURL,
      'approvedByParent': approvedByParent,
      'completedAt': completedAt,
      'kidID': kidID,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    String? proofPhotoURL,
    bool? approvedByParent,
    Timestamp? completedAt,
    String? kidID,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      proofPhotoURL: proofPhotoURL ?? this.proofPhotoURL,
      approvedByParent: approvedByParent ?? this.approvedByParent,
      completedAt: completedAt ?? this.completedAt,
      kidID: kidID ?? this.kidID,
    );
  }
}
