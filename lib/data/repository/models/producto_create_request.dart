// lib/data/repository/models/producto_create_request.dart
class ProductoCreateRequest {
  final String nombre;
  final String descripcion;
  final String estadoProducto;
  final String categoria;
  final String almacen;
  final String ubicacion;
  final int existencia;
  final String estadoStock;

  ProductoCreateRequest({
    required this.nombre,
    required this.descripcion,
    required this.estadoProducto,
    required this.categoria,
    required this.almacen,
    required this.ubicacion,
    required this.existencia,
    required this.estadoStock,
  });

  Map<String, dynamic> toJson() {
    return {
      'producto': nombre,
      'descripcion': descripcion,
      'estadoProducto': estadoProducto,
      'categoria': categoria,
      'almacen': almacen,
      'ubicacion': ubicacion,
      'existencia': existencia,
      'estadoStock': estadoStock,
    };
  }
}
