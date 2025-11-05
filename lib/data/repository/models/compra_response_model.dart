class CompraResponseModel {
  final String mensaje;
  final String numeroFactura;

  CompraResponseModel({required this.mensaje, required this.numeroFactura});

  factory CompraResponseModel.fromJson(Map<String, dynamic> json) {
    return CompraResponseModel(
      mensaje: json['mensaje'] ?? '',
      numeroFactura: json['numeroFactura'] ?? '',
    );
  }
}
