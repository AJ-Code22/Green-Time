class ChildProfile {
  final String username;
  final String? displayName;
  final String? profileImageUrl;
  final int totalEcoPoints;
  final int completedTasks;
  final int pendingApprovals;

  ChildProfile({
    required this.username,
    this.displayName,
    this.profileImageUrl,
    this.totalEcoPoints = 0,
    this.completedTasks = 0,
    this.pendingApprovals = 0,
  });

  factory ChildProfile.fromMap(Map<String, dynamic> map) {
    return ChildProfile(
      username: map['username'] as String,
      displayName: map['displayName'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      totalEcoPoints: map['ecoPoints'] as int? ?? 0,
      completedTasks: map['completedTasks'] as int? ?? 0,
      pendingApprovals: map['pendingApprovals'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'ecoPoints': totalEcoPoints,
      'completedTasks': completedTasks,
      'pendingApprovals': pendingApprovals,
    };
  }
}
