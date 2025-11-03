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
      mensaje: json['message'] ?? '', 
      exito: json['success'] ?? false, 
    );
  }
}
