import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ VERIFICAR CON BACKEND — cambiar por la IP de Claudio
  static const String baseUrl = 'http://localhost:3000';

  static Future<dynamic> get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('GET $endpoint falló: ${res.statusCode}');
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await http.post(Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    if (res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('POST $endpoint falló: ${res.statusCode}');
  }

  static Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final res = await http.patch(Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('PATCH $endpoint falló: ${res.statusCode}');
  }

  static Future<void> delete(String endpoint) async {
    final res = await http.delete(Uri.parse('$baseUrl$endpoint'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('DELETE $endpoint falló: ${res.statusCode}');
    }
  }
}
