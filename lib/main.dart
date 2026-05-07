import 'package:flutter/material.dart';
import 'package:task_hub/auth/login_page.dart';

void main() {
  runApp(const TaskHubApp());
}

// ================= MODEL DATA DUMMY =================
class Task {
  String id;
  String title;
  String description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });
}

class TaskHubApp extends StatelessWidget {
  const TaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}