import '../entities/compra_entity.dart';
import '../repositories/compra_repository.dart';
import '../../data/repository/models/compra_response_model.dart';

class CrearCompra {
  final CompraRepository repository;

  CrearCompra(this.repository);

  Future<CompraResponseModel> execute(Compra compra) {
    return repository.registrarCompra(compra);
  }
}
