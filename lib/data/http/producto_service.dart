import 'dart:convert';
import 'package:http/http.dart' as http;
import '../repository/models/producto_model.dart';

class ProductoService {
  final String baseUrl;

  ProductoService({this.baseUrl = 'http://192.168.1.80:5138'});

  Future<List<ProductoModel>> obtenerProductosActivos(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Producto/activos?PageNumber=$pageNumber&PageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List data = json['items'];
      return data.map((item) => ProductoModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
