class Compra {
  final String numeroFactura;
  final String proveedor;
  final String usuario;
  final List<String> productos;
  final List<int> cantidades;
  final List<double> preciosCompra;
  final List<double> preciosVenta;
  final List<String> codigosLote;
  final List<DateTime> fechasEntrada;
  final List<DateTime> fechasVencimiento;

  Compra({
    required this.numeroFactura,
    required this.proveedor,
    required this.usuario,
    required this.productos,
    required this.cantidades,
    required this.preciosCompra,
    required this.preciosVenta,
    required this.codigosLote,
    required this.fechasEntrada,
    required this.fechasVencimiento,
  });

  Map<String, dynamic> toJson() => {
        "numeroFactura": numeroFactura,
        "proveedor": proveedor,
        "usuario": usuario,
        "productos": productos,
        "cantidades": cantidades,
        "preciosCompra": preciosCompra,
        "preciosVenta": preciosVenta,
        "codigosLote": codigosLote,
        "fechasEntrada": fechasEntrada.map((d) => d.toIso8601String()).toList(),
        "fechasVencimiento": fechasVencimiento.map((d) => d.toIso8601String()).toList(),
      };
}
