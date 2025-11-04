import '../../../domain/entities/producto_entity.dart';

class ProductoModel {
  final String nombre;
  final String descripcion;
  final String estadoProducto;
  final String categoria;
  final int existencia;
  final double precioCompra;
  final double precioVenta;
  final String lote;
  final DateTime? fechaEntrada;
  final DateTime? fechaVencimiento;
  final String estadoStock;

  ProductoModel({
    required this.nombre,
    required this.descripcion,
    required this.estadoProducto,
    required this.categoria,
    required this.existencia,
    required this.precioCompra,
    required this.precioVenta,
    required this.lote,
    this.fechaEntrada,
    this.fechaVencimiento,
    required this.estadoStock,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      return DateTime.tryParse(dateStr);
    }

    return ProductoModel(
      nombre: json['producto'] ?? '-',
      descripcion: json['descripcion'] ?? '-',
      estadoProducto: json['estadoProducto'] ?? '-',
      categoria: json['categoria'] ?? '-',
      existencia: json['existencia'] != null
          ? int.tryParse(json['existencia'].toString()) ?? 0
          : 0,
      precioCompra: json['precio_Compra'] != null
          ? double.tryParse(json['precio_Compra'].toString()) ?? 0.0
          : 0.0,
      precioVenta: json['precio_Venta'] != null
          ? double.tryParse(json['precio_Venta'].toString()) ?? 0.0
          : 0.0,
      lote: json['lote'] ?? '-',
      fechaEntrada: parseDate(json['fecha_Entrada']),
      fechaVencimiento: parseDate(json['fecha_Vencimiento']),
      estadoStock: json['estadoStock'] ?? '-',
    );
  }

  ProductoEntity toEntity() {
    return ProductoEntity(
      nombre: nombre,
      descripcion: descripcion,
      estadoProducto: estadoProducto,
      categoria: categoria,
      existencia: existencia,
      precioCompra: precioCompra,
      precioVenta: precioVenta,
      lote: lote,
      fechaEntrada: fechaEntrada,
      fechaVencimiento: fechaVencimiento,
      estadoStock: estadoStock,
    );
  }
}
