class Task {
  final String id;
  final String title;
  final String description;
  final int points;
  bool isCompleted;
  bool isApproved;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isCompleted = false,
    this.isApproved = false,
  });
}

// Mock tasks
final List<Task> sampleTasks = [
  Task(id: '1', title: 'Recycle Bottles', description: 'Collect and sort plastic bottles for recycling', points: 10),
  Task(id: '2', title: 'Turn Off Lights', description: 'Switch off lights when leaving a room', points: 5),
  Task(id: '3', title: 'Plant a Seed', description: 'Plant a seed and water it', points: 15),
  Task(id: '4', title: 'Use Reusable Bags', description: 'Help with grocery shopping using cloth bags', points: 8),
  Task(id: '5', title: 'Save Water', description: 'Turn off tap while brushing teeth', points: 6),
];
