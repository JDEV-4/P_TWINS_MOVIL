import 'package:flutter/material.dart';
import '../../domain/entities/compra_entity.dart';
import '../../domain/usecases/crear_compra.dart';
import '../../data/repository/models/compra_response_model.dart';

class CompraController extends ChangeNotifier {
  final CrearCompra crearCompraUseCase;

  bool isLoading = false;
  String errorMessage = '';
  CompraResponseModel? compraRegistrada;

  CompraController(this.crearCompraUseCase);

  Future<void> registrarCompra(Compra compra) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      compraRegistrada = await crearCompraUseCase.execute(compra);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
