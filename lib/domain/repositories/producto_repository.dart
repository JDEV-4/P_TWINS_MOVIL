// lib/domain/repositories/producto_repository.dart
import '../entities/producto_entity.dart';
import '../../data/repository/models/producto_response_model.dart';

abstract class ProductoRepository {
  Future<List<ProductoEntity>> obtenerProductosActivos(int pageNumber, int pageSize);

  //método para crear producto
  Future<ProductoResponseModel> crearProducto(ProductoEntity producto);

  Future<List<String>> obtenerCategorias();

}
