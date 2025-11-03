import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.82:5138/api/Auth';

  Future<Map<String, dynamic>> login(String usuario, String clave) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'usuario': usuario, 'clave': clave});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'usuario': data['usuario'],
          'rol': data['rol'],
          'sexo': data['sexo'], 
          'token': data['token'],
        };
      } else {
        return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
