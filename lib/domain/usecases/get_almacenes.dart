import '../entities/almacen_entity.dart';
import '../repositories/almacen_repository.dart';

class GetAlmacenes {
  final AlmacenRepository repository;

  GetAlmacenes(this.repository);

  Future<List<AlmacenEntity>> execute() {
    return repository.obtenerAlmacenes();
  }
}
