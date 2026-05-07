import 'package:flutter/material.dart';
import 'package:task_hub/component/task_card.dart';
import 'package:task_hub/main.dart';
import 'package:task_hub/page/add_task_page.dart';
import 'package:task_hub/page/profile_page.dart';
import 'package:task_hub/page/task_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data dummy awal
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Design UI Wireframes',
      description: 'Buat wireframe untuk halaman login, home, dan settings di Figma.',
      isDone: false,
    ),
    Task(
      id: '2',
      title: 'Setup GitHub Repo',
      description: 'Push file markdown user stories ke dalam repository baru.',
      isDone: true,
    ),
  ];

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    int pendingTasks = tasks.where((t) => !t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Hello, Hustler! 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'You have $pendingTasks pending tasks today.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onToggle: () => toggleTask(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(task: task),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () async {
          // Navigasi ke halaman tambah tugas dan tunggu kembalian data
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
          
          if (newTask != null && newTask is Task) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}