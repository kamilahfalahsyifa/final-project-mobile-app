import 'package:flutter/material.dart';
import 'package:task_hub/services/storage_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool _notificationsEnabled;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = StorageService.getNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for your tasks'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              StorageService.setNotificationsEnabled(val);
            },
          ),
          ListTile(
            title: const Text('Default Reminder Time'),
            subtitle: Text(_reminderTime.format(context)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _reminderTime,
              );
              if (time != null) {
                setState(() => _reminderTime = time);
              }
            },
          ),
        ],
      ),
    );
  }
}