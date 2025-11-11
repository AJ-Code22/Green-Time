// models/task_data.dart
import 'task.dart'; // make sure Task class is imported

// Mock data
final List<Task> sampleTasks = [
  Task(
    id: '1',
    title: 'Recycle Bottles',
    description: 'Collect and sort plastic bottles for recycling',
    points: 10,
    kidID: 'dummy_kid_id',
  ),
  Task(
    id: '2',
    title: 'Turn Off Lights',
    description: 'Switch off lights when leaving a room',
    points: 5,
    kidID: 'dummy_kid_id',
  ),
  Task(
    id: '3',
    title: 'Plant a Seed',
    description: 'Plant a seed and water it',
    points: 15,
    kidID: 'dummy_kid_id',
  ),
  Task(
    id: '4',
    title: 'Use Reusable Bags',
    description: 'Help with grocery shopping using cloth bags',
    points: 8,
    kidID: 'dummy_kid_id',
  ),
  Task(
    id: '5',
    title: 'Save Water',
    description: 'Turn off tap while brushing teeth',
    points: 6,
    kidID: 'dummy_kid_id',
  ),
];
