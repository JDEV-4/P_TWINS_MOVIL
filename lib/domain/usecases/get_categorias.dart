import '../repositories/producto_repository.dart';

class GetCategorias {
  final ProductoRepository repository;

  GetCategorias(this.repository);

  Future<List<String>> execute() {
    return repository.obtenerCategorias();
  }
}
