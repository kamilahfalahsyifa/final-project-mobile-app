import 'package:task_hub/main.dart';
import 'package:task_hub/services/storage_service.dart';

class TasksService {
  static List<Task> tasks = [
    Task(id: '1', title: 'Design UI Wireframes', description: 'Buat wireframe untuk halaman login, home, dan settings di Figma.', isDone: false),
    Task(id: '2', title: 'Setup GitHub Repo', description: 'Push file markdown user stories ke dalam repository baru.', isDone: true),
  ];

  static Future<void> loadTasks() async {
    final data = StorageService.loadTasks();
    if (data.isNotEmpty) {
      tasks = data.map((m) => Task.fromMap(m)).toList();
    }
  }

  static Future<void> saveTasks() async {
    await StorageService.saveTasks(tasks.map((t) => t.toMap()).toList());
  }

  static void addTask(Task task) {
    tasks.add(task);
    saveTasks();
  }

  static void removeTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    saveTasks();
  }

  static void toggleTask(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index].isDone = !tasks[index].isDone;
      saveTasks();
    }
  }

  static void updateTask(Task updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      saveTasks();
    }
  }
}