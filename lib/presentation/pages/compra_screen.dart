import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../data/http/compra_api.dart';
import 'carrito_screen.dart';

class CompraScreen extends StatefulWidget {
  final String nombreUsuario;

  const CompraScreen({super.key, required this.nombreUsuario});

  @override
  State<CompraScreen> createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> {
  final CompraApi api = CompraApi();

  final TextEditingController proveedorController = TextEditingController();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController precioCompraController = TextEditingController();
  final TextEditingController precioVentaController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController numeroFacturaController = TextEditingController();

  DateTime fechaEntrada = DateTime.now();
  DateTime fechaVencimiento = DateTime.now().add(const Duration(days: 30));

  List<Map<String, dynamic>> productosAgregados = [];

  @override
  void dispose() {
    proveedorController.dispose();
    productoController.dispose();
    cantidadController.dispose();
    precioCompraController.dispose();
    precioVentaController.dispose();
    loteController.dispose();
    numeroFacturaController.dispose();
    super.dispose();
  }

  void agregarProducto() {
    if (numeroFacturaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes ingresar el número de factura")),
      );
      return;
    }
    if (loteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes ingresar el código de lote")),
      );
      return;
    }
    if (proveedorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes seleccionar un proveedor")),
      );
      return;
    }
    if (productoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes seleccionar un producto")),
      );
      return;
    }
    if (cantidadController.text.isEmpty ||
        int.tryParse(cantidadController.text) == null ||
        int.parse(cantidadController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cantidad inválida")),
      );
      return;
    }
    if (precioCompraController.text.isEmpty ||
        double.tryParse(precioCompraController.text) == null ||
        double.parse(precioCompraController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Precio de compra inválido")),
      );
      return;
    }
    if (precioVentaController.text.isEmpty ||
        double.tryParse(precioVentaController.text) == null ||
        double.parse(precioVentaController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Precio de venta inválido")),
      );
      return;
    }

    setState(() {
      productosAgregados.add({
        'nombre': productoController.text,
        'cantidad': int.parse(cantidadController.text),
        'precioCompra': double.parse(precioCompraController.text),
        'precioVenta': double.parse(precioVentaController.text),
        'lote': loteController.text,
        'fechaEntrada': fechaEntrada,
        'fechaVencimiento': fechaVencimiento,
      });

      productoController.clear();
      cantidadController.clear();
      precioCompraController.clear();
      precioVentaController.clear();
    });
  }

  void irACarrito() async {
    if (productosAgregados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No has agregado productos")),
      );
      return;
    }

    final productosActualizados =
        await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(
        builder: (_) => CarritoScreen(
          productos: productosAgregados,
          numeroFactura: numeroFacturaController.text,
          proveedor: proveedorController.text,
          usuario: widget.nombreUsuario,
        ),
      ),
    );

    if (productosActualizados != null) {
      setState(() {
        productosAgregados = productosActualizados;
      });
    }
  }

  Future<List<String>> buscarProveedores(String termino) async {
    try {
      return await api.buscarProveedoresPorRazonSocial(termino);
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> buscarProductos(String termino) async {
    try {
      final resultado = await api.buscarProductosActivos(termino);
      return resultado
          .where((e) => e['Producto'] != null)
          .map((e) => e['Producto'].toString())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B81);
    const Color backgroundColor = Color(0xFFFFF8F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Registrar Compra",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Número de Factura
                          _buildSection(
                            "Número de Factura",
                            _buildSimpleField(
                              "Número de Factura",
                              numeroFacturaController,
                              "FACT-0001",
                              Icons.receipt_long,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              toUpperCase: true,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Código de Lote
                          _buildSection(
                            "Código de Lote",
                            _buildSimpleField(
                              "Código de Lote",
                              loteController,
                              "",
                              Icons.qr_code,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              toUpperCase: true,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Proveedor
                          _buildSection(
                            "Proveedor",
                            _buildTypeAheadField(
                              proveedorController,
                              buscarProveedores,
                              "Buscar proveedor",
                              Icons.business,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Producto
                          _buildSection(
                            "Producto",
                            _buildTypeAheadField(
                              productoController,
                              buscarProductos,
                              "Buscar producto",
                              Icons.inventory,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Cantidad / Precio Compra / Precio Venta
                          Row(
                            children: [
                              Expanded(
                                child: _buildSection(
                                  "Cantidad",
                                  _buildSimpleField(
                                    "Cantidad",
                                    cantidadController,
                                    "1",
                                    Icons.numbers,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSection(
                                  "Precio C.",
                                  _buildSimpleField(
                                    "Precio Compra",
                                    precioCompraController,
                                    "0.00",
                                    Icons.attach_money,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSection(
                                  "Precio Venta",
                                  _buildSimpleField(
                                    "Precio Venta",
                                    precioVentaController,
                                    "0.00",
                                    Icons.trending_up,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Fechas
                          Row(
                            children: [
                              Expanded(
                                child: _buildSection(
                                  "Fecha Entrada",
                                  _buildDateField(
                                    fechaEntrada,
                                    (picked) =>
                                        setState(() => fechaEntrada = picked),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSection(
                                  "Fecha Vencimiento",
                                  _buildDateField(
                                    fechaVencimiento,
                                    (picked) =>
                                        setState(() => fechaVencimiento = picked),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: _buildGradientButton(
                      "Agregar",
                      Icons.add_circle,
                      agregarProducto,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGradientButton(
                      "Ver", 
                      Icons.list_alt,
                      irACarrito,
                      isSecondary: true,
                      isEnabled: productosAgregados.isNotEmpty,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------
  Widget _buildTypeAheadField(
      TextEditingController controller,
      Future<List<String>> Function(String) searchFunction,
      String hint,
      IconData icon) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: _buildInputDecoration(hint, icon),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return [];
        return await searchFunction(pattern);
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSuggestionSelected: (String suggestion) {
        controller.text = suggestion;
      },
      noItemsFoundBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No se encontraron resultados'),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    const borderColor = Color(0xFFFF6B81);
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: borderColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor, width: 2),
      ),
    );
  }

  Widget _buildSection(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _buildSimpleField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.number,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool toUpperCase = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      onChanged: toUpperCase
          ? (value) {
              controller.value = controller.value.copyWith(
                text: value.toUpperCase(),
                selection: controller.selection,
              );
            }
          : null,
      decoration: _buildInputDecoration(hint, icon),
    );
  }

  Widget _buildDateField(DateTime date, ValueChanged<DateTime> onPicked) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        decoration: _buildInputDecoration("", Icons.calendar_today),
        child: Text(
          dateFormat.format(date),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isSecondary = false,
    bool isEnabled = true,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? (isEnabled ? Colors.grey.shade700 : Colors.grey.shade400)
              : (isEnabled ? const Color(0xFFFF6B81) : Colors.grey.shade400),
        ),
      ),
    );
  }
}
