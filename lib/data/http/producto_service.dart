import 'dart:convert';
import 'package:http/http.dart' as http;
import '../repository/models/producto_model.dart';
import '../repository/models/producto_response_model.dart';
import '../repository/models/producto_create_request.dart';
import '../../domain/entities/producto_entity.dart';

class ProductoService {
  final String baseUrl;

  ProductoService({this.baseUrl = 'http://192.168.1.83:5138'});

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

  Future<ProductoResponseModel> crearProducto(ProductoEntity producto) async {
    final request = ProductoCreateRequest(
      nombre: producto.nombre,
      descripcion: producto.descripcion,
      estadoProducto: producto.estadoProducto,
      categoria: producto.categoria,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/api/Producto/crear'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductoResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear producto');
    }
  }

  Future<List<String>> obtenerCategorias() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Producto/categorias'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => item['nombre'].toString()).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }
}
