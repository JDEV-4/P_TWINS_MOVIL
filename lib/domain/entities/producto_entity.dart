class ProductoEntity {
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

  ProductoEntity({
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
}



//class ProductoResponse {
  //final List<Producto> items;


   // required this.totalPages,
  //});

  //factory ProductoResponse.fromJson(Map<String, dynamic> json) => ProductoResponse(
  //      items: List<Producto>.from(json['items'].map((x) => Producto.fromJson(x))),
  //      totalRecords: json['totalRecords'],
    //    pageNumber: json['pageNumber'],
      //  pageSize: json['pageSize'],
        //totalPages: json['totalPages'],
   //   );
//}