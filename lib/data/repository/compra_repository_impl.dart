import '../../domain/entities/compra_entity.dart';
import '../../domain/repositories/compra_repository.dart';
import '../http/compra_service.dart';
import 'models/compra_response_model.dart';

class CompraRepositoryImpl implements CompraRepository {
  final CompraService service;

  CompraRepositoryImpl({required this.service});

  @override
  Future<CompraResponseModel> registrarCompra(Compra compra) {
    return service.registrarCompra(compra);
  }
}
