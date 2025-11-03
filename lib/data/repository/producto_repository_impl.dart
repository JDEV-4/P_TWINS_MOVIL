// lib/data/repository/producto_repository_impl.dart
import '../../domain/entities/producto_entity.dart';
import '../../domain/repositories/producto_repository.dart';
import '../http/producto_service.dart';
import '../repository/models/producto_model.dart';
import '../repository/models/producto_response_model.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoService service;

  ProductoRepositoryImpl({ProductoService? service})
      : service = service ?? ProductoService();

  @override
  Future<List<ProductoEntity>> obtenerProductosActivos(int pageNumber, int pageSize) async {
    final response = await service.obtenerProductosActivos(pageNumber, pageSize);
    return response.map((p) => p.toEntity()).toList();
  }

  @override
  Future<ProductoResponseModel> crearProducto(ProductoEntity producto) async {
    return await service.crearProducto(producto);
  }
}
