// lib/data/repository/models/producto_response_model.dart
class ProductoResponseModel {
  final String mensaje;
  final bool exito;

  ProductoResponseModel({
    required this.mensaje,
    required this.exito,
  });

  factory ProductoResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductoResponseModel(
      mensaje: json['message'] ?? '', // mapeamos 'message' del JSON a 'mensaje'
      exito: json['success'] ?? false, // mapeamos 'success' del JSON a 'exito'
    );
  }
}
