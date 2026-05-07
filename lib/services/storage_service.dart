import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      print('StorageService: Using in-memory fallback due to: $e');
    }
  }

  static Future<void> setDarkMode(bool value) async {
    await init();
    try {
      await _prefs?.setBool('dark_mode', value);
    } catch (e) {
      print('Error setDarkMode: $e');
    }
  }

  static bool getDarkMode() {
    try {
      return _prefs?.getBool('dark_mode') ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setUserData(String name, String email) async {
    await init();
    try {
      await _prefs?.setString('user_name', name);
      await _prefs?.setString('user_email', email);
    } catch (e) {
      print('Error setUserData: $e');
    }
  }

  static Map<String, String?> getUserData() {
    try {
      return {
        'name': _prefs?.getString('user_name'),
        'email': _prefs?.getString('user_email'),
      };
    } catch (e) {
      return {'name': null, 'email': null};
    }
  }

  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    await init();
    try {
      await _prefs?.setString('tasks', jsonEncode(tasks));
    } catch (e) {
      print('Error saveTasks: $e');
    }
  }

  static List<Map<String, dynamic>> loadTasks() {
    if (_prefs == null) return _getDefaultTasks();
    try {
      final data = _prefs?.getString('tasks');
      if (data == null || data.isEmpty) return _getDefaultTasks();
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error loadTasks: $e');
      return _getDefaultTasks();
    }
  }

  static List<Map<String, dynamic>> _getDefaultTasks() {
    return [
      {'id': '1', 'title': 'Design UI Wireframes', 'description': 'Buat wireframe untuk halaman login, home, dan settings di Figma.', 'isDone': false, 'color': 'blue', 'label': 'Work'},
      {'id': '2', 'title': 'Setup GitHub Repo', 'description': 'Push file markdown user stories ke dalam repository baru.', 'isDone': true, 'color': 'green', 'label': 'Personal'},
    ];
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    await init();
    try {
      await _prefs?.setBool('notifications_enabled', value);
    } catch (e) {
      print('Error setNotificationsEnabled: $e');
    }
  }

  static bool getNotificationsEnabled() {
    try {
      return _prefs?.getBool('notifications_enabled') ?? true;
    } catch (e) {
      return true;
    }
  }
}