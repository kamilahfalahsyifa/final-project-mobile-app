import 'package:flutter/material.dart';
import 'package:task_hub/component/task_card.dart';
import 'package:task_hub/component/navigation_drawer.dart';
import 'package:task_hub/main.dart';
import 'package:task_hub/page/add_task_page.dart';
import 'package:task_hub/page/task_detail_page.dart';
import 'package:task_hub/services/tasks_service.dart';
import 'package:task_hub/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _quote = 'The only way to do great work is to love what you do.';
  String _author = 'Steve Jobs';
  double _temperature = 28;
  String _weatherDesc = 'Partly Cloudy';
  bool _isLoadingApi = true;

  @override
  void initState() {
    super.initState();
    TasksService.loadTasks();
    _loadApiData();
  }

  Future<void> _loadApiData() async {
    final quoteResult = await ApiService.fetchQuote();
    final weatherResult = await ApiService.fetchWeather();

    if (mounted) {
      setState(() {
        _quote = quoteResult['content'] ?? _quote;
        _author = quoteResult['author'] ?? _author;
        _temperature = (weatherResult['temperature'] ?? 28).toDouble();
        _weatherDesc = weatherResult['description'] ?? _weatherDesc;
        _isLoadingApi = false;
      });
    }
  }

  void toggleTask(int index) {
    TasksService.toggleTask(TasksService.tasks[index].id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = TasksService.tasks;
    int pendingTasks = tasks.where((t) => !t.isDone).length;
    int completedTasks = tasks.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.task_alt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text('TaskHub', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadApiData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Hello, Hustler! 👋',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.thermostat, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${_temperature.toInt()}°C',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'You have $pendingTasks pending, $completedTasks completed.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.grey.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.format_quote, color: Colors.white54, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _weatherDesc,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        if (_isLoadingApi)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$_quote"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- $_author',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'My Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Tap + to add one!'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
              const SizedBox(height: 80),
            ],
          ),
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