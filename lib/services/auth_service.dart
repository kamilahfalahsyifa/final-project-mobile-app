class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      return {'success': false, 'error': 'Email and password are required.'};
    }

    if (!email.contains('@')) {
      return {'success': false, 'error': 'Please enter a valid email address.'};
    }

    if (password.length < 6) {
      return {'success': false, 'error': 'Password must be at least 6 characters.'};
    }

    // For demo purposes, accept any valid-looking credentials
    // In production, this would call an API
    return {'success': true};
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return {'success': false, 'error': 'All fields are required.'};
    }

    if (!email.contains('@')) {
      return {'success': false, 'error': 'Please enter a valid email address.'};
    }

    if (password.length < 6) {
      return {'success': false, 'error': 'Password must be at least 6 characters.'};
    }

    return {'success': true};
  }
}