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

  Map<String, dynamic> toJsonForSP() => {
        "NombreProveedor": proveedor,
        "NombreUsuario": usuario,
        "NumFactura": numeroFactura,
        "Productos": productos.join(','), 
        "Cantidades": cantidades.join(','),
        "PreciosCompra": preciosCompra.map((e) => e.toString()).join(','),
        "PreciosVenta": preciosVenta.map((e) => e.toString()).join(','),
        "CodigosLote": codigosLote.join(','),
        "FechasEntrada": fechasEntrada.map((d) => d.toIso8601String()).join(','),
        "FechasVencimiento": fechasVencimiento.map((d) => d.toIso8601String()).join(','),
      };
}

class CompraResponseDTO {
  final String mensaje;
  final String numeroFactura;

  CompraResponseDTO({required this.mensaje, required this.numeroFactura});

  factory CompraResponseDTO.fromJson(Map<String, dynamic> json) {
    return CompraResponseDTO(
      mensaje: json['Mensaje'],
      numeroFactura: json['NumeroFactura'],
    );
  }
}
