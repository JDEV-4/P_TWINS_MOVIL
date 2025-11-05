import '../entities/compra_entity.dart';
import '../../data/repository/models/compra_response_model.dart';

abstract class CompraRepository {
  Future<CompraResponseModel> registrarCompra(Compra compra);
}
