import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<dynamic> get(String endpoint) async {
    final respuesta = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (respuesta.statusCode == 200) return jsonDecode(respuesta.body);
    throw Exception('GET $endpoint falló: ${respuesta.statusCode}');
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> cuerpo) async {
    final respuesta = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cuerpo),
    );
    if (respuesta.statusCode == 201) return jsonDecode(respuesta.body);
    throw Exception('POST $endpoint falló: ${respuesta.statusCode}');
  }

  static Future<dynamic> patch(String endpoint, Map<String, dynamic> cuerpo) async {
    final respuesta = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cuerpo),
    );
    if (respuesta.statusCode == 200) return jsonDecode(respuesta.body);
    throw Exception('PATCH $endpoint falló: ${respuesta.statusCode}');
  }

  static Future<void> delete(String endpoint) async {
    final respuesta = await http.delete(Uri.parse('$baseUrl$endpoint'));
    if (respuesta.statusCode != 200 && respuesta.statusCode != 204) {
      throw Exception('DELETE $endpoint falló: ${respuesta.statusCode}');
    }
  }
}