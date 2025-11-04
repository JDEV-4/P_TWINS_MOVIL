import '../../domain/entities/almacen_entity.dart';
import '../../domain/entities/ubicacion_entity.dart';
import '../../domain/repositories/almacen_repository.dart';
import '../http/almacen_service.dart';

class AlmacenRepositoryImpl implements AlmacenRepository {
  final AlmacenService service;

  AlmacenRepositoryImpl({AlmacenService? service})
      : service = service ?? AlmacenService();

  @override
  Future<List<AlmacenEntity>> obtenerAlmacenes() async {
    final data = await service.obtenerAlmacenes();
    return data.map((a) => a.toEntity()).toList();
  }

  @override
  Future<List<UbicacionEntity>> obtenerUbicacionesPorAlmacen(int idAlmacen) async {
    final data = await service.obtenerUbicacionesPorAlmacen(idAlmacen);
    return data.map((u) => u.toEntity()).toList();
  }
}
