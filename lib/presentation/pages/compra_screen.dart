import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/compra_controller.dart';
import '../../domain/entities/compra_entity.dart';

class CompraScreen extends StatefulWidget {
  final String nombreUsuario;
  const CompraScreen({super.key, required this.nombreUsuario});

  @override
  State<CompraScreen> createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> {
  final TextEditingController proveedorController = TextEditingController();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController(text: '1');
  final TextEditingController precioCompraController = TextEditingController(text: '0');
  final TextEditingController precioVentaController = TextEditingController(text: '0');
  final TextEditingController codigoLoteController = TextEditingController();
  final TextEditingController fechaEntradaController = TextEditingController();
  final TextEditingController fechaVencimientoController = TextEditingController();

  final DateFormat formatoFecha = DateFormat('dd/MM/yyyy');
  List<Map<String, dynamic>> productosAgregados = [];

  double subtotal = 0;
  double iva = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    final ahora = DateTime.now();
    fechaEntradaController.text = formatoFecha.format(ahora);
    fechaVencimientoController.text = formatoFecha.format(ahora.add(const Duration(days: 30)));
  }

  void _agregarProducto() {
    if (productoController.text.isEmpty) return;

    setState(() {
      productosAgregados.add({
        'producto': productoController.text,
        'cantidad': int.tryParse(cantidadController.text) ?? 1,
        'precioCompra': double.tryParse(precioCompraController.text) ?? 0,
        'precioVenta': double.tryParse(precioVentaController.text) ?? 0,
        'codigoLote': codigoLoteController.text,
        'fechaEntrada': fechaEntradaController.text,
        'fechaVencimiento': fechaVencimientoController.text,
      });
      _calcularTotales();
      _limpiarCamposProducto();
    });
  }

  void _limpiarCamposProducto() {
    productoController.clear();
    cantidadController.text = '1';
    precioCompraController.text = '0';
    precioVentaController.text = '0';
    codigoLoteController.clear();
    final ahora = DateTime.now();
    fechaEntradaController.text = formatoFecha.format(ahora);
    fechaVencimientoController.text = formatoFecha.format(ahora.add(const Duration(days: 30)));
  }

  void _seleccionarFecha(TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      initialDate = formatoFecha.parse(controller.text);
    } catch (_) {}
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = formatoFecha.format(picked);
    }
  }

  void _calcularTotales() {
    double s = 0;
    for (var p in productosAgregados) {
      s += p['cantidad'] * p['precioCompra'];
    }
    setState(() {
      subtotal = s;
      iva = subtotal * 0.13;
      total = subtotal + iva;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CompraController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      appBar: AppBar(
        title: const Text(
          'Registrar Compra',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B81),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputFieldConLabel(
                label: 'Proveedor',
                controller: proveedorController,
                hint: 'Ingrese el nombre del proveedor'),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Izquierda: Inputs
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _inputFieldConLabel(
                              label: 'Nombre del Producto',
                              controller: productoController,
                              hint: 'Producto'),
                          const SizedBox(height: 8),
                          _inputFieldConLabel(
                              label: 'Cantidad',
                              controller: cantidadController,
                              hint: '1'),
                          const SizedBox(height: 8),
                          _inputFieldConLabel(
                              label: 'Precio Compra',
                              controller: precioCompraController,
                              hint: '0'),
                          const SizedBox(height: 8),
                          _inputFieldConLabel(
                              label: 'Precio Venta',
                              controller: precioVentaController,
                              hint: '0'),
                          const SizedBox(height: 8),
                          _inputFieldConLabel(
                              label: 'Código de Lote',
                              controller: codigoLoteController,
                              hint: ''),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _seleccionarFecha(fechaEntradaController),
                            child: AbsorbPointer(
                              child: _inputFieldConLabel(
                                  label: 'Fecha Entrada',
                                  controller: fechaEntradaController),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _seleccionarFecha(fechaVencimientoController),
                            child: AbsorbPointer(
                              child: _inputFieldConLabel(
                                  label: 'Fecha Vencimiento',
                                  controller: fechaVencimientoController),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _button('Agregar Producto', _agregarProducto,
                              color: const Color(0xFFFF6B81)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Derecha: Lista de productos agregados
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text('Productos Agregados',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFFF6B81))),
                          const SizedBox(height: 8),
                          Expanded(
                            child: productosAgregados.isEmpty
                                ? const Center(
                                    child: Text('No hay productos agregados'))
                                : ListView.builder(
                                    itemCount: productosAgregados.length,
                                    itemBuilder: (context, index) {
                                      final p = productosAgregados[index];
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: const Color(0xFFFFE5E8),
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: ListTile(
                                          title: Text(p['producto'],
                                              style: const TextStyle(
                                                  color: Color(0xFFFF6B81),
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Cantidad: ${p['cantidad']}'),
                                              Text(
                                                  'Precio Compra: ${p['precioCompra'].toStringAsFixed(2)}'),
                                              Text(
                                                  'Precio Venta: ${p['precioVenta'].toStringAsFixed(2)}'),
                                              Text('Código: ${p['codigoLote']}'),
                                              Text('Entrada: ${p['fechaEntrada']}'),
                                              Text(
                                                  'Vencimiento: ${p['fechaVencimiento']}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 12),
                          _totalesCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _button('Registrar Compra', () async {
              if (proveedorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Debe completar el proveedor')),
                );
                return;
              }

              // 👉 Nuevo mensaje elegante cuando no hay productos
              if (productosAgregados.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFFF6B81), size: 60),
                          const SizedBox(height: 16),
                          const Text(
                            'No se puede registrar la compra',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFF6B81),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Debe agregar al menos un producto antes de continuar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B81),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Entendido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                return;
              }

              final compra = Compra(
                numeroFactura:
                    DateTime.now().millisecondsSinceEpoch.toString(),
                proveedor: proveedorController.text,
                usuario: widget.nombreUsuario,
                productos: productosAgregados
                    .map((p) => p['producto'] as String)
                    .toList(),
                cantidades: productosAgregados
                    .map((p) => p['cantidad'] as int)
                    .toList(),
                preciosCompra: productosAgregados
                    .map((p) => p['precioCompra'] as double)
                    .toList(),
                preciosVenta: productosAgregados
                    .map((p) => p['precioVenta'] as double)
                    .toList(),
                codigosLote: productosAgregados
                    .map((p) => p['codigoLote'] as String)
                    .toList(),
                fechasEntrada: productosAgregados
                    .map((p) =>
                        formatoFecha.parse(p['fechaEntrada'] as String))
                    .toList(),
                fechasVencimiento: productosAgregados
                    .map((p) =>
                        formatoFecha.parse(p['fechaVencimiento'] as String))
                    .toList(),
              );

              await controller.registrarCompra(compra);
              setState(() {
                productosAgregados.clear();
                _calcularTotales();
              });
            }, color: const Color(0xFFFF6B81)),
          ],
        ),
      ),
    );
  }

  Widget _inputFieldConLabel({
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFFF6B81)),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint ?? '',
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6B81), width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6B81), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _button(String label, VoidCallback onPressed, {required Color color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _totalesCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _filaTotal('Subtotal', subtotal),
          _filaTotal('IVA (13%)', iva),
          const Divider(color: Colors.white70),
          _filaTotal('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget _filaTotal(String titulo, double valor, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(valor.toStringAsFixed(2),
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
