import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _quotesApiUrl = 'https://api.quotable.io/random';
  static const String _weatherApiUrl = 'https://api.open-meteo.com/v1/forecast';

  static Future<Map<String, dynamic>> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(_quotesApiUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'content': data['content'] ?? '',
          'author': data['author'] ?? 'Unknown',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch quote',
          'content': 'The only way to do great work is to love what you do.',
          'author': 'Steve Jobs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'content': 'The only way to do great work is to love what you do.',
        'author': 'Steve Jobs',
      };
    }
  }

  static Future<Map<String, dynamic>> fetchWeather({
    double latitude = -6.2088,
    double longitude = 106.8492,
  }) async {
    try {
      final url = Uri.parse(
        '$_weatherApiUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final current = data['current'] ?? {};
        return {
          'success': true,
          'temperature': current['temperature_2m'] ?? 0,
          'weatherCode': current['weather_code'] ?? 0,
          'description': _getWeatherDescription(current['weather_code'] ?? 0),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch weather',
          'temperature': 28,
          'description': 'Partly Cloudy',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'temperature': 28,
        'description': 'Partly Cloudy',
      };
    }
  }

  static String _getWeatherDescription(int code) {
    if (code == 0) return 'Clear Sky';
    if (code == 1 || code == 2 || code == 3) return 'Partly Cloudy';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 67) return 'Rainy';
    if (code >= 71 && code <= 77) return 'Snowy';
    if (code >= 80 && code <= 82) return 'Showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }
}