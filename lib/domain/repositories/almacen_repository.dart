import '../entities/almacen_entity.dart';
import '../entities/ubicacion_entity.dart';

abstract class AlmacenRepository {
  Future<List<AlmacenEntity>> obtenerAlmacenes();
  Future<List<UbicacionEntity>> obtenerUbicacionesPorAlmacen(int idAlmacen);
}
