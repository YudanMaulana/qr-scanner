// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<List<dynamic>> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('apiUrl');

    if (url == null || url.isEmpty) {
      throw Exception('URL API belum diset');
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> setApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiUrl', url);
  }
}
