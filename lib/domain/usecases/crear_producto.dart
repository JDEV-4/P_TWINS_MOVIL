import '../entities/producto_entity.dart';
import '../repositories/producto_repository.dart';
import '../../data/repository/models/producto_response_model.dart';

class CrearProducto {
  final ProductoRepository repository;

  CrearProducto(this.repository);

  Future<ProductoResponseModel> execute(ProductoEntity producto) {
    return repository.crearProducto(producto);
  }
}
