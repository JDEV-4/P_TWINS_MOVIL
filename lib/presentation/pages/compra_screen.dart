import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/http/compra_api.dart';
import '../../domain/models/CompraDTO.dart';

class CompraScreen extends StatefulWidget {
  final String nombreUsuario;
  const CompraScreen({Key? key, required this.nombreUsuario}) : super(key: key);

  @override
  State<CompraScreen> createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> with SingleTickerProviderStateMixin {
  final CompraApi api = CompraApi();

  // Controllers
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController facturaController = TextEditingController();
  final TextEditingController searchProductoController = TextEditingController();
  final TextEditingController searchProveedorController = TextEditingController();

  // Datos
  List<Map<String, dynamic>> productos = [];
  List<String> proveedores = [];

  // Estado UI
  bool loadingProductos = false;
  bool loadingProveedores = false;
  String errorProductos = '';
  String errorProveedores = '';
  String errorRegistrar = '';

  Map<String, dynamic>? productoSeleccionado;
  String? proveedorSeleccionado;

  int cantidad = 1;
  double precioCompra = 0;
  double precioVenta = 0;
  String codigoLote = '';
  DateTime? fechaEntrada;
  DateTime? fechaVencimiento;

  List<Map<String, dynamic>> detallesCompra = [];

  // Animación
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    usuarioController.text = widget.nombreUsuario;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    usuarioController.dispose();
    facturaController.dispose();
    searchProductoController.dispose();
    searchProveedorController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ====================
  // MÉTODOS DE LÓGICA
  // ====================
  Future<void> buscarProductos() async {
    final termino = searchProductoController.text.trim();
    setState(() {
      loadingProductos = true;
      errorProductos = '';
      productos = [];
    });
    try {
      final results = await api.buscarProductosActivos(termino.isEmpty ? null : termino);
      setState(() {
        productos = results;
      });
    } catch (e) {
      setState(() {
        errorProductos = 'Error al cargar productos: $e';
      });
    } finally {
      setState(() {
        loadingProductos = false;
      });
    }
  }

  void seleccionarProducto(Map<String, dynamic> prod) {
    setState(() {
      productoSeleccionado = prod;
      precioCompra = (prod['PrecioCompra'] ?? 0.0).toDouble();
      precioVenta = (prod['PrecioVenta'] ?? 0.0).toDouble();
      cantidad = 1;
      codigoLote = '';
      fechaEntrada = DateTime.now();
      fechaVencimiento = DateTime.now().add(const Duration(days: 365));
      productos = [];
      searchProductoController.text = prod['Producto'] ?? '';
    });
  }

  Future<void> buscarProveedores() async {
    final termino = searchProveedorController.text.trim();
    setState(() {
      loadingProveedores = true;
      errorProveedores = '';
      proveedores = [];
    });
    try {
      final results = await api.buscarProveedoresPorRazonSocial(termino.isEmpty ? null : termino);
      setState(() {
        proveedores = results;
      });
    } catch (e) {
      setState(() {
        errorProveedores = 'Error al cargar proveedores: $e';
      });
    } finally {
      setState(() {
        loadingProveedores = false;
      });
    }
  }

  void seleccionarProveedor(String prov) {
    setState(() {
      proveedorSeleccionado = prov;
      proveedores = [];
      searchProveedorController.text = prov;
    });
  }

  void agregarProductoALista() {
    if (productoSeleccionado == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Seleccione un producto')));
      return;
    }
    if (cantidad <= 0 || precioCompra <= 0 || precioVenta <= 0 || codigoLote.isEmpty || fechaEntrada == null || fechaVencimiento == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Complete todos los campos correctamente')));
      return;
    }
    if (fechaVencimiento!.isBefore(fechaEntrada!)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('La fecha de vencimiento no puede ser anterior a la de entrada')));
      return;
    }

    setState(() {
      detallesCompra.add({
        'Producto': productoSeleccionado!['Producto'],
        'Cantidad': cantidad,
        'PrecioCompra': precioCompra,
        'PrecioVenta': precioVenta,
        'CodigoLote': codigoLote,
        'FechaEntrada': fechaEntrada!,
        'FechaVencimiento': fechaVencimiento!,
      });

      productoSeleccionado = null;
      cantidad = 1;
      precioCompra = 0;
      precioVenta = 0;
      codigoLote = '';
      fechaEntrada = null;
      fechaVencimiento = null;
      searchProductoController.clear();
      _controller.forward(from: 0);
    });
  }

  void eliminarProductoDeLista(int index) {
    setState(() {
      detallesCompra.removeAt(index);
    });
  }

  Future<void> registrarCompra() async {
    if (usuarioController.text.isEmpty) {
      setState(() {
        errorRegistrar = 'Debe ingresar el usuario';
      });
      return;
    }
    if (facturaController.text.isEmpty) {
      setState(() {
        errorRegistrar = 'Debe ingresar el número de factura';
      });
      return;
    }
    if (proveedorSeleccionado == null) {
      setState(() {
        errorRegistrar = 'Debe seleccionar un proveedor';
      });
      return;
    }
    if (detallesCompra.isEmpty) {
      setState(() {
        errorRegistrar = 'Debe agregar al menos un producto';
      });
      return;
    }

    setState(() {
      errorRegistrar = '';
    });

    final List<String> productosList = detallesCompra.map((d) => d['Producto'] as String).toList();
    final List<int> cantidades = detallesCompra.map((d) => d['Cantidad'] as int).toList();
    final List<double> preciosCompra = detallesCompra.map((d) => d['PrecioCompra'] as double).toList();
    final List<double> preciosVenta = detallesCompra.map((d) => d['PrecioVenta'] as double).toList();
    final List<String> codigosLote = detallesCompra.map((d) => d['CodigoLote'] as String).toList();
    final List<DateTime> fechasEntrada = detallesCompra.map((d) => d['FechaEntrada'] as DateTime).toList();
    final List<DateTime> fechasVencimiento = detallesCompra.map((d) => d['FechaVencimiento'] as DateTime).toList();

    final compra = CompraDTO(
      proveedor: proveedorSeleccionado!,
      usuario: usuarioController.text.trim(),
      numeroFactura: facturaController.text.trim(),
      productos: productosList,
      cantidades: cantidades,
      preciosCompra: preciosCompra,
      preciosVenta: preciosVenta,
      codigosLote: codigosLote,
      fechasEntrada: fechasEntrada,
      fechasVencimiento: fechasVencimiento,
    );

    try {
      final response = await api.registrarCompra(compra.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra registrada: ${response['mensaje']}')));

      setState(() {
        detallesCompra.clear();
        searchProveedorController.clear();
        searchProductoController.clear();
        proveedorSeleccionado = null;
        productoSeleccionado = null;
        facturaController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> seleccionarFecha(BuildContext context, bool isEntrada) async {
    final DateTime initialDate = isEntrada ? (fechaEntrada ?? DateTime.now()) : (fechaVencimiento ?? DateTime.now().add(const Duration(days: 365)));
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.pinkAccent),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (selected != null) {
      setState(() {
        if (isEntrada) {
          fechaEntrada = selected;
        } else {
          fechaVencimiento = selected;
        }
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget buildProveedorBusqueda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchProveedorController,
          decoration: _inputDecoration('Buscar proveedor').copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.pinkAccent),
              onPressed: buscarProveedores,
            ),
          ),
          onChanged: (val) {
            if (val.isEmpty) {
              setState(() {
                proveedores = [];
              });
            }
          },
        ),
        if (loadingProveedores) const LinearProgressIndicator(),
        if (errorProveedores.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(errorProveedores, style: const TextStyle(color: Colors.red)),
          ),
        if (proveedores.isNotEmpty)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: proveedores.map((prov) => ListTile(
                title: Text(prov),
                onTap: () => seleccionarProveedor(prov),
                trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
              )).toList(),
            ),
          ),
        if (proveedorSeleccionado != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Proveedor seleccionado: ${proveedorSeleccionado!}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
          ),
      ],
    );
  }

  Widget buildProductoBusqueda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchProductoController,
          decoration: _inputDecoration('Buscar producto').copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.pinkAccent),
              onPressed: buscarProductos,
            ),
          ),
          onChanged: (val) {
            if (val.isEmpty) {
              setState(() {
                productos = [];
              });
            }
          },
        ),
        if (loadingProductos) const LinearProgressIndicator(),
        if (errorProductos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(errorProductos, style: const TextStyle(color: Colors.red)),
          ),
        if (productos.isNotEmpty)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: productos.map((prod) => ListTile(
                title: Text(prod['Producto'] ?? ''),
                subtitle: Text('Compra: \$${prod['PrecioCompra'] ?? 0.0}, Venta: \$${prod['PrecioVenta'] ?? 0.0}'),
                onTap: () => seleccionarProducto(prod),
                trailing: const Icon(Icons.add_shopping_cart, color: Colors.pinkAccent),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget buildDetalleProductoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.pink[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Detalles de ${productoSeleccionado?['Producto'] ?? 'Producto'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.pinkAccent),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Cantidad'),
                    controller: TextEditingController(text: cantidad.toString()),
                    onChanged: (val) => cantidad = int.tryParse(val) ?? 1,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Precio Compra'),
                    controller: TextEditingController(text: precioCompra.toString()),
                    onChanged: (val) => precioCompra = double.tryParse(val) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Precio Venta'),
                    controller: TextEditingController(text: precioVenta.toString()),
                    onChanged: (val) => precioVenta = double.tryParse(val) ?? 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: _inputDecoration('Código Lote'),
              onChanged: (val) => codigoLote = val,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.pinkAccent,
                      side: const BorderSide(color: Colors.pinkAccent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => seleccionarFecha(context, true),
                    label: Text(fechaEntrada != null
                        ? 'Entrada: ${DateFormat('dd/MM/yyyy').format(fechaEntrada!)}'
                        : 'Fecha entrada'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, color: Colors.pinkAccent),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.pinkAccent,
                      side: const BorderSide(color: Colors.pinkAccent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => seleccionarFecha(context, false),
                    label: Text(fechaVencimiento != null
                        ? 'Venc: ${DateFormat('dd/MM/yyyy').format(fechaVencimiento!)}'
                        : 'Fecha vencimiento'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.playlist_add),
              label: const Text('Añadir a la Compra', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: agregarProductoALista,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductosTarjetas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Productos a Registrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
        const SizedBox(height: 8),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: detallesCompra.length,
            itemBuilder: (context, index) {
              final detalle = detallesCompra[index];
              return ScaleTransition(
                scale: _animation,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detalle['Producto'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pinkAccent)),
                            const Divider(height: 10, thickness: 1, color: Colors.grey),
                            Text('Cant: **${detalle['Cantidad']}**'),
                            Text('Compra: **\$${detalle['PrecioCompra'].toStringAsFixed(2)}**'),
                            Text('Venta: **\$${detalle['PrecioVenta'].toStringAsFixed(2)}**'),
                            Text('Lote: **${detalle['CodigoLote']}**'),
                            Text('Entrada: **${DateFormat('dd/MM/yyyy').format(detalle['FechaEntrada'])}**'),
                            Text('Venc: **${DateFormat('dd/MM/yyyy').format(detalle['FechaVencimiento'])}**'),
                          ],
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                            onPressed: () => eliminarProductoDeLista(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Registrar Compra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pinkAccent,
        elevation: 6,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información General
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Información General',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: usuarioController,
                            decoration: _inputDecoration('Usuario'),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: facturaController,
                            decoration: _inputDecoration('N° Factura'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Selección de Proveedor
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Selección de Proveedor',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                    ),
                    const SizedBox(height: 12),
                    buildProveedorBusqueda(),
                  ],
                ),
              ),
            ),

            // Añadir Producto
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Añadir Producto',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                    ),
                    const SizedBox(height: 12),
                    buildProductoBusqueda(),
                    if (productoSeleccionado != null) buildDetalleProductoCard(),
                  ],
                ),
              ),
            ),

            // Productos en la compra
            if (detallesCompra.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: buildProductosTarjetas(),
                ),
              ),

            const SizedBox(height: 20),

            // Mensaje de error
            if (errorRegistrar.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(errorRegistrar, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),

            // Botón Registrar
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('REGISTRAR COMPRA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              onPressed: registrarCompra,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
