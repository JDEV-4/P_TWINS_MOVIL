// lib/domain/usecases/get_productos_activos.dart
import '../entities/producto_entity.dart';
import '../repositories/producto_repository.dart';

class GetProductosActivos {
  final ProductoRepository repository;

  GetProductosActivos(this.repository);

  Future<List<ProductoEntity>> call(int pageNumber, int pageSize) {
    return repository.obtenerProductosActivos(pageNumber, pageSize);
  }
}
