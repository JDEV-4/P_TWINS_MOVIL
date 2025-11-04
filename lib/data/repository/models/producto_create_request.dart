class ProductoCreateRequest {
  final String nombre;
  final String descripcion;
  final String estadoProducto;
  final String categoria;

  ProductoCreateRequest({
    required this.nombre,
    required this.descripcion,
    required this.estadoProducto,
    required this.categoria,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombreProducto': nombre,
      'descripcionProducto': descripcion,
      'nombreCategoria': categoria,
      'estado': estadoProducto.toLowerCase() == 'activo' ? true : false,
    };
  }
}
