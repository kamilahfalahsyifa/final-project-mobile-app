import 'package:flutter/material.dart';
import 'package:task_hub/main.dart';
import 'package:task_hub/services/tasks_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isWeekly = false;

  List<Task> get filteredTasks {
    if (_isWeekly) {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return TasksService.tasks.where((t) => t.isDone && t.id.compareTo(weekAgo.toString()) < 0).toList();
    }
    return TasksService.tasks.where((t) => t.isDone).toList();
  }

  List<Task> get pendingTasks => TasksService.tasks.where((t) => !t.isDone).toList();

  @override
  Widget build(BuildContext context) {
    final completedTasks = filteredTasks;
    final pending = pendingTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Daily')),
                ButtonSegment(value: true, label: Text('Weekly')),
              ],
              selected: {_isWeekly},
              onSelectionChanged: (selected) {
                setState(() => _isWeekly = selected.first);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _SummaryCard(title: 'Completed', count: completedTasks.length, color: Colors.green, icon: Icons.check_circle_outline)),
                const SizedBox(width: 12),
                Expanded(child: _SummaryCard(title: 'Pending', count: pending.length, color: Colors.orange, icon: Icons.pending_outlined)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Completed Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: completedTasks.isEmpty
                  ? const Center(child: Text('No completed tasks yet'))
                  : ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
                        return ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _SummaryCard({required this.title, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}