// lib/presentation/controllers/producto_controller.dart
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_activos.dart';
import '../../domain/usecases/crear_producto.dart';
import '../../data/repository/producto_repository_impl.dart';
import '../../data/repository/models/producto_response_model.dart';

class ProductoController {
  final GetProductosActivos getProductosActivos;
  late final CrearProducto crearProductoUseCase;

  ProductoController({required this.getProductosActivos}) {
    final repository = ProductoRepositoryImpl();
    crearProductoUseCase = CrearProducto(repository);
  }

  Future<List<ProductoEntity>> fetchProductos(int pageNumber, int pageSize) {
    return getProductosActivos(pageNumber, pageSize);
  }

  Future<String> crearProducto(ProductoEntity producto) async {
    try {
      final response = await crearProductoUseCase.execute(producto);
      return response.mensaje; // Ahora coincide con el modelo
    } catch (e) {
      return 'Error al crear producto: $e';
    }
  }
}
