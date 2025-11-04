import '../../domain/entities/almacen_entity.dart';
import '../../domain/entities/ubicacion_entity.dart';
import '../../domain/usecases/get_almacenes.dart';
import '../../domain/usecases/get_ubicaciones_por_almacen.dart';
import '../../data/repository/almacen_repository_impl.dart';

class AlmacenController {
  final GetAlmacenes getAlmacenesUseCase;
  final GetUbicacionesPorAlmacen getUbicacionesUseCase;

  AlmacenController(AlmacenRepositoryImpl repository)
      : getAlmacenesUseCase = GetAlmacenes(repository),
        getUbicacionesUseCase = GetUbicacionesPorAlmacen(repository);

  Future<List<AlmacenEntity>> fetchAlmacenes() async {
    return await getAlmacenesUseCase.execute();
  }

  Future<List<UbicacionEntity>> fetchUbicaciones(int idAlmacen) async {
    return await getUbicacionesUseCase.execute(idAlmacen);
  }
}
