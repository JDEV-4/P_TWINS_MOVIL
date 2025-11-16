// compra_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompraApi {
  final String baseUrl;

  CompraApi({this.baseUrl = 'http://10.237.178.206:5138'});

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

  Future<CompraResponseDTO> registrarCompra(CompraDTO compraDto) async {
    final uri = _buildUri('/api/Compra/registrar');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(compraDto.toJson()),
    );

    if (response.statusCode == 200) {
      return CompraResponseDTO.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error['mensaje'] ?? 'Error al registrar compra');
    }
  }
}

// DTOs
class CompraDTO {
  final String proveedor;
  final String usuario;
  final String numeroFactura;
  final List<String> productos;
  final List<int> cantidades;
  final List<double> preciosCompra;
  final List<double> preciosVenta;
  final List<String> codigosLote;
  final List<DateTime> fechasEntrada;
  final List<DateTime> fechasVencimiento;

  CompraDTO({
    required this.proveedor,
    required this.usuario,
    required this.numeroFactura,
    required this.productos,
    required this.cantidades,
    required this.preciosCompra,
    required this.preciosVenta,
    required this.codigosLote,
    required this.fechasEntrada,
    required this.fechasVencimiento,
  });

  Map<String, dynamic> toJson() => {
        "proveedor": proveedor,
        "usuario": usuario,
        "numeroFactura": numeroFactura,
        "productos": productos,
        "cantidades": cantidades,
        "preciosCompra": preciosCompra,
        "preciosVenta": preciosVenta,
        "codigosLote": codigosLote,
        "fechasEntrada": fechasEntrada.map((d) => d.toIso8601String()).toList(),
        "fechasVencimiento": fechasVencimiento.map((d) => d.toIso8601String()).toList(),
      };
}

class CompraResponseDTO {
  final String mensaje;
  final String numeroFactura;

  CompraResponseDTO({required this.mensaje, required this.numeroFactura});

  factory CompraResponseDTO.fromJson(Map<String, dynamic> json) {
    return CompraResponseDTO(
      mensaje: json['mensaje'],
      numeroFactura: json['numeroFactura'],
    );
  }
}
