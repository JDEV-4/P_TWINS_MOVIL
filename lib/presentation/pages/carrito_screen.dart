import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import '../../data/http/compra_api.dart';

class CarritoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> productos;
  final String numeroFactura;
  final String proveedor;
  final String usuario;

  const CarritoScreen({
    super.key,
    required this.productos,
    required this.numeroFactura,
    required this.proveedor,
    required this.usuario,
  });

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  late List<Map<String, dynamic>> productos;

  @override
  void initState() {
    super.initState();
    productos = List<Map<String, dynamic>>.from(widget.productos);
  }

  double get subtotal =>
      productos.fold(0, (sum, p) => sum + (p['precioCompra'] * p['cantidad']));
  double get iva => subtotal * 0.13;
  double get total => subtotal + iva;

  void eliminarProducto(int index) {
    setState(() {
      productos.removeAt(index);
    });

    if (productos.isEmpty) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) Navigator.pop(context, productos);
      });
    }
  }

  void modificarProducto(int index) async {
    final producto = Map<String, dynamic>.from(productos[index]);

    final TextEditingController nombreController =
        TextEditingController(text: producto['nombre']);
    final TextEditingController cantidadController =
        TextEditingController(text: producto['cantidad'].toString());
    final TextEditingController precioCompraController =
        TextEditingController(text: producto['precioCompra'].toString());
    final TextEditingController precioVentaController =
        TextEditingController(text: producto['precioVenta'].toString());
    final TextEditingController loteController =
        TextEditingController(text: producto['lote'] ?? '');

    DateTime fechaEntrada = producto['fechaEntrada'];
    DateTime fechaVencimiento = producto['fechaVencimiento'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Modificar producto",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildField("Nombre", nombreController, Icons.icecream),
                  const SizedBox(height: 10),
                  _buildField("Cantidad", cantidadController, Icons.numbers,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  _buildField("Precio compra", precioCompraController,
                      Icons.attach_money,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  _buildField("Precio venta", precioVentaController,
                      Icons.trending_up,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  _buildField("Código de lote", loteController, Icons.qr_code),
                  const SizedBox(height: 10),
                  _buildDatePicker(
                    "Fecha de entrada",
                    fechaEntrada,
                    (picked) =>
                        setModalState(() => fechaEntrada = picked ?? fechaEntrada),
                  ),
                  const SizedBox(height: 10),
                  _buildDatePicker(
                    "Fecha de vencimiento",
                    fechaVencimiento,
                    (picked) =>
                        setModalState(() => fechaVencimiento = picked ?? fechaVencimiento),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          productos[index] = {
                            'nombre': nombreController.text.trim(),
                            'cantidad': int.tryParse(cantidadController.text) ?? 1,
                            'precioCompra':
                                double.tryParse(precioCompraController.text) ?? 0,
                            'precioVenta':
                                double.tryParse(precioVentaController.text) ?? 0,
                            'lote': loteController.text.trim(),
                            'fechaEntrada': fechaEntrada,
                            'fechaVencimiento': fechaVencimiento,
                          };
                        });
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Guardar cambios"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B81),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> registrarCompraBackend() async {
    if (productos.isEmpty) {
      _mostrarMensaje(context, "No hay productos para registrar");
      return;
    }

    try {
      final compraDto = CompraDTO(
        proveedor: widget.proveedor,
        usuario: widget.usuario,
        numeroFactura: widget.numeroFactura,
        productos:
            List<String>.from(productos.map((p) => p['nombre'].toString())),
        cantidades: List<int>.from(productos.map((p) => p['cantidad'] as int)),
        preciosCompra:
            List<double>.from(productos.map((p) => p['precioCompra'] as double)),
        preciosVenta:
            List<double>.from(productos.map((p) => p['precioVenta'] as double)),
        codigosLote: List<String>.from(productos.map((p) => p['lote'] ?? '')),
        fechasEntrada:
            List<DateTime>.from(productos.map((p) => p['fechaEntrada'] as DateTime)),
        fechasVencimiento: List<DateTime>.from(
            productos.map((p) => p['fechaVencimiento'] as DateTime)),
      );

      final api = CompraApi();
      final response = await api.registrarCompra(compraDto);

      _mostrarMensaje(context, response.mensaje);
      setState(() => productos.clear());
      Navigator.pop(context, productos);
    } catch (e) {
      _mostrarMensaje(context, "Error al registrar la compra: $e");
    }
  }

  void finalizarCompra() {
    if (productos.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                color: Color(0xFFFF6B81), size: 56),
            const SizedBox(height: 12),
            const Text(
              "¿Qué deseas hacer?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              "Selecciona una opción para continuar con la compra",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 22),
            _actionButton(
              icon: Icons.save_alt_rounded,
              text: "Solo guardar compra",
              color: const Color(0xFFFF6B81),
              onTap: () async {
                Navigator.pop(context);
                await registrarCompraBackend();
              },
            ),
            const SizedBox(height: 12),
            _actionButton(
              icon: Icons.receipt_long_outlined,
              text: "Crear factura y registrar",
              color: Colors.deepPurpleAccent,
              onTap: () async {
                Navigator.pop(context);
                await _crearFacturaPDF();
                await registrarCompraBackend();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearFacturaPDF() async {
    try {
      final pdf = pw.Document();

      final logo = await rootBundle.load('assets/images/logo.png');
      final imageLogo = pw.MemoryImage(logo.buffer.asUint8List());

      final numeroFactura = widget.numeroFactura;
      final fechaActual = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      const proveedorNombre = 'Distribuidora Paletitas Twins';
      const proveedorDireccion = 'Carazo, Nicaragua';
      const proveedorTelefono = '+505 8888-9999';
      const proveedorEmail = 'proveedores@twins.com';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(width: 80, height: 80, child: pw.Image(imageLogo)),
                    pw.SizedBox(height: 8),
                    pw.Text('Paletitas Twins',
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(0xFFFF6B81))),
                    pw.Text('Factura de Compra', style: pw.TextStyle(fontSize: 14)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('N° Factura: $numeroFactura',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Fecha: $fechaActual'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Text('Proveedor:',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(proveedorNombre),
            pw.Text(proveedorDireccion),
            pw.Text('Tel: $proveedorTelefono'),
            pw.Text('Correo: $proveedorEmail'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Producto', 'Cantidad', 'Precio C.', 'Subtotal'],
              data: productos.map((p) {
                final subtotalProd = p['precioCompra'] * p['cantidad'];
                return [
                  p['nombre'],
                  '${p['cantidad']}',
                  '\$${p['precioCompra'].toStringAsFixed(2)}',
                  '\$${subtotalProd.toStringAsFixed(2)}',
                ];
              }).toList(),
              border:
                  pw.TableBorder.all(width: 0.5, color: PdfColor.fromInt(0xFFCCCCCC)),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFFFF6B81),
              ),
              cellStyle: const pw.TextStyle(fontSize: 12),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFF0F3)),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  pw.Text('IVA (13%): \$${iva.toStringAsFixed(2)}'),
                  pw.Text('Total: \$${total.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text('Gracias por su compra',
                  style: pw.TextStyle(
                      color: PdfColor.fromInt(0xFFFF6B81),
                      fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
      );

      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/Factura_$numeroFactura.pdf');
      await file.writeAsBytes(await pdf.save());

      _mostrarMensaje(context, "Factura creada correctamente");
      await OpenFile.open(file.path);
    } catch (e) {
      _mostrarMensaje(context, "Error al crear la factura: $e");
    }
  }

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFF6B81),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B81)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime date, ValueChanged<DateTime?> onPicked) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        onPicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          prefixIcon:
              const Icon(Icons.calendar_today, color: Color(0xFFFF6B81)),
        ),
        child: Text(dateFormat.format(date)),
      ),
    );
  }

  Widget _buildResumen() {
    const Color primaryColor = Color(0xFFFF6B81);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          _buildResumenRow("Subtotal", subtotal),
          _buildResumenRow("IVA (13%)", iva),
          const Divider(thickness: 1.2),
          _buildResumenRow("Total", total, isBold: true, color: primaryColor),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: finalizarCompra,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                "Finalizar Compra",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenRow(String label, double value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? Colors.black87)),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B81);
    const Color backgroundColor = Color(0xFFFFF8F8);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, productos);
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Carrito de Productos",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: productos.isEmpty
            ? const Center(
                child: Text("No hay productos agregados",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final p = productos[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey[100]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['nombre'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Cantidad: ${p['cantidad']}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Precio: \$${p['precioCompra'].toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => modificarProducto(index),
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B81)
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.edit,
                                              color: Color(0xFFFF6B81)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => eliminarProducto(index),
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.delete,
                                              color: Colors.redAccent),
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
                    _buildResumen(),
                  ],
                ),
              ),
      ),
    );
  }
}
