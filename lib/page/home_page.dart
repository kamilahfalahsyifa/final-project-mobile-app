import 'package:flutter/material.dart';
import 'package:task_hub/component/task_card.dart';
import 'package:task_hub/component/navigation_drawer.dart';
import 'package:task_hub/main.dart';
import 'package:task_hub/page/add_task_page.dart';
import 'package:task_hub/page/task_detail_page.dart';
import 'package:task_hub/services/tasks_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    TasksService.loadTasks();
  }

  void toggleTask(int index) {
    TasksService.toggleTask(TasksService.tasks[index].id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = TasksService.tasks;
    int pendingTasks = tasks.where((t) => !t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
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
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Tap + to add one!'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          onToggle: () => toggleTask(index),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailPage(task: task),
                              ),
                            );
                            setState(() {});
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
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );

          if (newTask != null && newTask is Task) {
            TasksService.addTask(newTask);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}