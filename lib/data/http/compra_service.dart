import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/compra_entity.dart';
import '../repository/models/compra_response_model.dart';

class CompraService {
  final String baseUrl;

  CompraService({required this.baseUrl});

  Future<CompraResponseModel> registrarCompra(Compra compra) async {
    final url = Uri.parse('$baseUrl/api/compra/registrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(compra.toJson()),
    );

    if (response.statusCode == 200) {
      return CompraResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar compra: ${response.body}');
    }
  }
}
