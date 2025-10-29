// lib/presentation/controllers/producto_controller.dart
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_activos.dart';

class ProductoController {
  final GetProductosActivos getProductosActivos;

  ProductoController({required this.getProductosActivos});

  Future<List<ProductoEntity>> fetchProductos(int pageNumber, int pageSize) {
    return getProductosActivos(pageNumber, pageSize);
  }
}
