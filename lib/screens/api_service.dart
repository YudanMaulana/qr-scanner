import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchData() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/YudanMaulana/wedding-json/refs/heads/main/random_names.json'); // URL API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode JSON response
    } else {
      throw Exception('Failed to load data');
    }
  }
}
