import 'package:flutter/material.dart';
import 'package:task_hub/main.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: task.isDone ? Colors.grey.shade50 : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task.isDone ? Colors.green : Colors.grey,
              ),
              onPressed: onToggle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}