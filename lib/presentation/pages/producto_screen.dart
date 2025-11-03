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

  // --- Detalles del producto ---
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
                    _detalleCampo('Categoría', p.categoria),
                    _detalleCampo('Almacén', p.almacen),
                    _detalleCampo('Ubicación', p.ubicacion),
                    _detalleCampo('Existencia', p.existencia?.toString()),
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

  // --- FORMULARIO AGREGAR PRODUCTO MODERNIZADO ---
  void _mostrarFormularioAgregar() {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final categoriaController = TextEditingController();
    final almacenController = TextEditingController();
    final ubicacionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Text(
                    'Agregar Producto',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B81),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(nombreController, 'Nombre'),
                  _buildInputField(descripcionController, 'Descripción'),
                  _buildInputField(categoriaController, 'Categoría'),
                  _buildInputField(almacenController, 'Almacén'),
                  _buildInputField(ubicacionController, 'Ubicación'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B81),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final nuevoProducto = ProductoEntity(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        categoria: categoriaController.text,
                        almacen: almacenController.text,
                        ubicacion: ubicacionController.text,
                        precioCompra: 0.0,
                        precioVenta: 0.0,
                        lote: '',
                        fechaEntrada: null,
                        fechaVencimiento: null,
                        estadoProducto: 'Activo',
                        existencia: 0,
                        estadoStock: 'Disponible',
                      );

                      try {
                        final mensaje = await controller.crearProducto(nuevoProducto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(mensaje)),
                        );
                        Navigator.pop(context);

                        setState(() {
                          productos.clear();
                          pageNumber = 1;
                          hasMore = true;
                          _cargarProductos();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text(
                      'Agregar Producto',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFFF6B81)),
          filled: true,
          fillColor: Colors.grey[100],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6B81), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
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
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
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
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
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
                                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B81),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _mostrarFormularioAgregar,
      ),
    );
  }
}
