import '../entities/ubicacion_entity.dart';
import '../repositories/almacen_repository.dart';

class GetUbicacionesPorAlmacen {
  final AlmacenRepository repository;

  GetUbicacionesPorAlmacen(this.repository);

  Future<List<UbicacionEntity>> execute(int idAlmacen) {
    return repository.obtenerUbicacionesPorAlmacen(idAlmacen);
  }
}
