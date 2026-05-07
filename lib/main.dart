import 'package:flutter/material.dart';
import 'package:task_hub/auth/login_page.dart';
import 'package:task_hub/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const TaskHubApp());
}

class Task {
  String id;
  String title;
  String description;
  bool isDone;
  String color;
  String label;
  DateTime? reminder;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.color = '',
    this.label = '',
    this.reminder,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone,
    'color': color,
    'label': label,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    isDone: map['isDone'] ?? false,
    color: map['color'] ?? '',
    label: map['label'] ?? '',
  );
}

class TaskHubApp extends StatefulWidget {
  const TaskHubApp({super.key});

  @override
  State<TaskHubApp> createState() => TaskHubAppState();
}

class TaskHubAppState extends State<TaskHubApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() {
    setState(() {
      _isDarkMode = StorageService.getDarkMode();
    });
  }

  void toggleDarkMode() async {
    await StorageService.setDarkMode(!_isDarkMode);
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskHub',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: const LoginPage(),
    );
  }

  ThemeData get _lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.light),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  ThemeData get _darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}