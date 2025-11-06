class CompraDTO {
  final String proveedor;
  final String usuario;
  final String numeroFactura;
  final List<String> productos;
  final List<int> cantidades;
  final List<double> preciosCompra;
  final List<double> preciosVenta;
  final List<String> codigosLote;
  final List<DateTime> fechasEntrada;
  final List<DateTime> fechasVencimiento;

  CompraDTO({
    required this.proveedor,
    required this.usuario,
    required this.numeroFactura,
    required this.productos,
    required this.cantidades,
    required this.preciosCompra,
    required this.preciosVenta,
    required this.codigosLote,
    required this.fechasEntrada,
    required this.fechasVencimiento,
  });

  // Aquí convertimos a JSON con listas, no CSV
  Map<String, dynamic> toJson() => {
        "proveedor": proveedor,
        "usuario": usuario,
        "numeroFactura": numeroFactura,
        "productos": productos,
        "cantidades": cantidades,
        "preciosCompra": preciosCompra,
        "preciosVenta": preciosVenta,
        "codigosLote": codigosLote,
        "fechasEntrada": fechasEntrada.map((d) => d.toIso8601String()).toList(),
        "fechasVencimiento": fechasVencimiento.map((d) => d.toIso8601String()).toList(),
      };
}

class CompraResponseDTO {
  final String mensaje;
  final String numeroFactura;

  CompraResponseDTO({required this.mensaje, required this.numeroFactura});

  factory CompraResponseDTO.fromJson(Map<String, dynamic> json) {
    return CompraResponseDTO(
      mensaje: json['mensaje'] ?? json['Mensaje'] ?? '',
      numeroFactura: json['numeroFactura'] ?? json['NumeroFactura'] ?? '',
    );
  }
}
