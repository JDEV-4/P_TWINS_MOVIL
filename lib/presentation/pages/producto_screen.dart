import 'package:flutter/material.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_activos.dart';
import '../controllers/producto_controller.dart';
import '../widgets/producto_card.dart';
import '../../data/repository/producto_repository_impl.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  late ProductoController controller;
  List<ProductoEntity> productos = [];
  int pageNumber = 1;
  final int pageSize = 5;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();

    final repository = ProductoRepositoryImpl();
    final getProductosActivos = GetProductosActivos(repository);
    controller = ProductoController(getProductosActivos: getProductosActivos);

    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final nuevosProductos =
          await controller.fetchProductos(pageNumber, pageSize);

      setState(() {
        productos.addAll(nuevosProductos);
        pageNumber++;
        if (nuevosProductos.length < pageSize) hasMore = false;
      });
    } catch (e) {
      debugPrint('Error al cargar productos: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 50) {
                  _cargarProductos();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final p = productos[index];
                  return ProductoCard(
                    nombre: p.nombre,
                    descripcion: p.descripcion,
                    estadoProducto: p.estadoProducto,
                    categoria: p.categoria,
                    almacen: p.almacen,
                    ubicacion: p.ubicacion,
                    existencia: p.existencia,
                    precioCompra: p.precioCompra,
                    precioVenta: p.precioVenta,
                    lote: p.lote,
                    fechaEntrada: formatDate(p.fechaEntrada),
                    fechaVencimiento: formatDate(p.fechaVencimiento),
                    estadoStock: p.estadoStock,
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
