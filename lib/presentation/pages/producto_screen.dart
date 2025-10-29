import 'package:flutter/material.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_activos.dart';
import '../controllers/producto_controller.dart';
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

  // --- BottomSheet minimalista ---
  void _mostrarDetalles(ProductoEntity p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controllerScroll) {
            return SingleChildScrollView(
              controller: controllerScroll,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra superior
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Nombre del producto
                    Text(
                      p.nombre,
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B81),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Descripción
                    Text(
                      p.descripcion ?? '-',
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    // Información tipo tabla
                    _detalleCampo('Categoría', p.categoria),
                    _detalleCampo('Almacén', p.almacen),
                    _detalleCampo('Ubicación', p.ubicacion),
                    _detalleCampo('Existencia', p.existencia?.toString()),
                    _detalleCampo('Precio Compra',
                        p.precioCompra != null ? '\$${p.precioCompra!.toStringAsFixed(2)}' : '-'),
                    _detalleCampo('Precio Venta',
                        p.precioVenta != null ? '\$${p.precioVenta!.toStringAsFixed(2)}' : '-'),
                    _detalleCampo('Lote', p.lote),
                    _detalleCampo('Fecha Entrada', formatDate(p.fechaEntrada)),
                    _detalleCampo('Fecha Vencimiento', formatDate(p.fechaVencimiento)),
                    _detalleCampo('Estado Stock', p.estadoStock),
                    _detalleCampo('Estado Producto', p.estadoProducto),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget para filas tipo tabla
  Widget _detalleCampo(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF6B81),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                padding: const EdgeInsets.all(10),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final p = productos[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          // Izquierda: título + descripción + categoría
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nombre,
                                  style: const TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFFF6B81),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.descripcion ?? '-',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (p.categoria != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE5E8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      p.categoria!,
                                      style: const TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontSize: 12,
                                        color: Color(0xFFFF6B81),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Derecha: precio + botón ojo
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${p.precioVenta?.toStringAsFixed(2) ?? '-'}',
                                style: const TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 24,
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey),
                                  onPressed: () => _mostrarDetalles(p),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Color(0xFFFF6B81)),
            ),
        ],
      ),
    );
  }
}
