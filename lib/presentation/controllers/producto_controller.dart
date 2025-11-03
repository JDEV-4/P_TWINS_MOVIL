import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_activos.dart';
import '../../domain/usecases/crear_producto.dart';
import '../../domain/usecases/get_categorias.dart';
import '../../data/repository/producto_repository_impl.dart';

class ProductoController {
  final GetProductosActivos getProductosActivos;
  late final CrearProducto crearProductoUseCase;
  late final GetCategorias getCategoriasUseCase;

  ProductoController({
    required this.getProductosActivos,
    required ProductoRepositoryImpl repository,
  }) {
    crearProductoUseCase = CrearProducto(repository);
    getCategoriasUseCase = GetCategorias(repository);
  }

  // --- Productos ---
  Future<List<ProductoEntity>> fetchProductos(int pageNumber, int pageSize) {
    return getProductosActivos(pageNumber, pageSize);
  }

  Future<String> crearProducto(ProductoEntity producto) async {
    try {
      final response = await crearProductoUseCase.execute(producto);
      return response.mensaje;
    } catch (e) {
      return 'Error al crear producto: $e';
    }
  }

  // --- Categorías ---
  Future<List<String>> fetchCategorias() {
    return getCategoriasUseCase.execute();
  }
}
