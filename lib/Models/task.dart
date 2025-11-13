class Task {
  final String id;
  final String title;
  final String description;
  final int points;
  final String? proofPhotoURL;
  final bool approvedByParent;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final String? kidID;
  final String? parentID;
  final bool isSubmitted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.proofPhotoURL,
    this.approvedByParent = false,
    this.completedAt,
    this.createdAt,
    this.kidID,
    this.parentID,
    this.isSubmitted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    String? proofPhotoURL,
    bool? approvedByParent,
    DateTime? completedAt,
    DateTime? createdAt,
    String? kidID,
    String? parentID,
    bool? isSubmitted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      proofPhotoURL: proofPhotoURL ?? this.proofPhotoURL,
      approvedByParent: approvedByParent ?? this.approvedByParent,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      kidID: kidID ?? this.kidID,
      parentID: parentID ?? this.parentID,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
  factory Task.fromDocument(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      proofPhotoURL: data['proofPhotoURL'],
      approvedByParent: data['approvedByParent'] ?? false,
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      kidID: data['kidID'],
      parentID: data['parentID'],
      isSubmitted: data['isSubmitted'] ?? false,
    );
  }

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      proofPhotoURL: data['proofPhotoURL'],
      approvedByParent: data['approvedByParent'] ?? false,
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      kidID: data['kidID'],
      parentID: data['parentID'],
      isSubmitted: data['isSubmitted'] ?? false,
    );
  }
}

