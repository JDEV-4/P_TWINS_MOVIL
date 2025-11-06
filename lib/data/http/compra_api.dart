import 'dart:convert';
import 'package:http/http.dart' as http;

class CompraApi {
  final String baseUrl;

  CompraApi({this.baseUrl = 'http://192.168.1.83:5138'});

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }

  Future<List<Map<String, dynamic>>> buscarProductosActivos(String? termino) async {
    final uri = _buildUri('/api/Compra/buscar-productos',
        (termino == null || termino.isEmpty) ? null : {'termino': termino});

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al buscar productos');
    }
  }

  Future<List<String>> buscarProveedoresPorRazonSocial(String? termino) async {
    final uri = _buildUri('/api/Compra/buscar-proveedores',
        (termino == null || termino.isEmpty) ? null : {'termino': termino});

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return List<String>.from(data);
    } else {
      throw Exception('Error al buscar proveedores');
    }
  }

  Future<Map<String, dynamic>> registrarCompra(Map<String, dynamic> compraDto) async {
    final uri = _buildUri('/api/Compra/registrar');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json-patch+json'},
      body: json.encode(compraDto),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['mensaje'] ?? 'Error al registrar compra');
    }
  }
}
  