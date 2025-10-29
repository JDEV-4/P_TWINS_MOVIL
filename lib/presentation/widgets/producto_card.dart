import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
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
  final String fechaEntrada;
  final String fechaVencimiento;
  final String estadoStock;

  const ProductoCard({
    super.key,
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
    required this.fechaEntrada,
    required this.fechaVencimiento,
    required this.estadoStock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Descripción: $descripcion'),
            Text('Estado: $estadoProducto'),
            Text('Categoría: $categoria'),
            Text('Almacén: $almacen'),
            Text('Ubicación: $ubicacion'),
            Text('Existencia: $existencia'),
            Text('Precio Compra: \$${precioCompra.toStringAsFixed(2)}'),
            Text('Precio Venta: \$${precioVenta.toStringAsFixed(2)}'),
            Text('Lote: $lote'),
            Text('Entrada: $fechaEntrada'),
            Text('Vencimiento: $fechaVencimiento'),
            Text('Estado Stock: $estadoStock'),
          ],
        ),
      ),
    );
  }
}
