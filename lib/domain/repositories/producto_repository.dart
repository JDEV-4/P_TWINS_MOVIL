// lib/domain/repositories/producto_repository.dart
import '../entities/producto_entity.dart';

abstract class ProductoRepository {
  Future<List<ProductoEntity>> obtenerProductosActivos(int pageNumber, int pageSize);
}
