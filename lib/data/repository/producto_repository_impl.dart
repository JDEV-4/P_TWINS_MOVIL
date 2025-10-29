import '../../domain/entities/producto_entity.dart';
import '../../domain/repositories/producto_repository.dart';
import '../http/producto_service.dart';
import '../../data/repository/producto_repository_impl.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoService service;

  ProductoRepositoryImpl({ProductoService? service})
      : service = service ?? ProductoService();

  @override
  Future<List<ProductoEntity>> obtenerProductosActivos(
      int pageNumber, int pageSize) async {
    final response = await service.obtenerProductosActivos(pageNumber, pageSize);
    // response ya debe ser List<ProductoModel>
    return response.map((p) => p.toEntity()).toList();
  }
}
