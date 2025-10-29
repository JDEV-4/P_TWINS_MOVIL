// lib/data/repository/models/producto_model.dart
import '../../../domain/entities/producto_entity.dart';

class ProductoModel {
  final String nombre;
  final String descripcion;
  final String estadoProducto;
  final String categoria;
  final String almacen;
  final String ubicacion;
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
    required this.almacen,
    required this.ubicacion,
    required this.existencia,
    required this.precioCompra,
    required this.precioVenta,
    required this.lote,
    this.fechaEntrada,
    this.fechaVencimiento,
    required this.estadoStock,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      nombre: json['producto'] ?? '-',                // JSON 'producto' -> nombre
      descripcion: json['descripcion'] ?? '-',
      estadoProducto: json['estadoProducto'] ?? '-',
      categoria: json['categoria'] ?? '-',
      almacen: json['almacen'] ?? '-',
      ubicacion: json['ubicacion'] ?? '-',
      existencia: json['existencia'] ?? 0,
      precioCompra: (json['precio_Compra'] as num?)?.toDouble() ?? 0.0, // JSON 'precio_Compra' -> precioCompra
      precioVenta: (json['precio_Venta'] as num?)?.toDouble() ?? 0.0,   // JSON 'precio_Venta' -> precioVenta
      lote: json['lote'] ?? '-',
      fechaEntrada: json['fecha_Entrada'] != null
          ? DateTime.parse(json['fecha_Entrada'])
          : null,
      fechaVencimiento: json['fecha_Vencimiento'] != null
          ? DateTime.parse(json['fecha_Vencimiento'])
          : null,
      estadoStock: json['estadoStock'] ?? '-',
    );
  }

  ProductoEntity toEntity() {
    return ProductoEntity(
      nombre: nombre,
      descripcion: descripcion,
      estadoProducto: estadoProducto,
      categoria: categoria,
      almacen: almacen,
      ubicacion: ubicacion,
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
