import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final String clientName;
  final String seller;
  final DateTime date;

  const InvoiceScreen({
    super.key,
    required this.cart,
    required this.clientName,
    required this.seller,
    required this.date,
  });

  // ======== CALCULOS DE FACTURA ========
  double get subtotal => cart.fold(
      0, (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int));

  double get iva => subtotal * 0.15; // 15% de IVA
  double get total => subtotal + iva;

  // ======== FUNCIÓN PARA IMPRIMIR PDF =========
  Future<void> _printInvoice() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Paletitas Twins',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Factura de Venta',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text('Cliente: $clientName'),
                pw.Text('Vendedor: $seller'),
                pw.Text(
                    'Fecha: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
                pw.Divider(height: 24),
                pw.Text('Detalle de Productos:',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Producto', 'Cantidad', 'Precio', 'Total'],
                  data: cart
                      .map((item) => [
                            item['name'],
                            item['quantity'].toString(),
                            "C\$${(item['price'] as double).toStringAsFixed(2)}",
                            "C\$${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}",
                          ])
                      .toList(),
                  headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.teal),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellStyle: const pw.TextStyle(fontSize: 12),
                  cellHeight: 28,
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Subtotal: C\$${subtotal.toStringAsFixed(2)}"),
                      pw.Text("IVA: C\$${iva.toStringAsFixed(2)}"),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        "Total: C\$${total.toStringAsFixed(2)}",
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.teal),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Center(
                  child: pw.Text(
                    "¡Gracias por tu compra!",
                    style: pw.TextStyle(
                        fontSize: 16, color: PdfColors.teal600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // ======== INTERFAZ VISUAL =========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Factura de Venta",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Encabezado del negocio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Paletitas Twins",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Información del cliente y vendedor
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cliente: $clientName",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("Vendedor: $seller",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    "Fecha: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de productos
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Productos",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${item['name']} x ${item['quantity']}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(
                                  "C\$${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Totales
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTotalRow("Subtotal:", subtotal),
                  const SizedBox(height: 6),
                  _buildTotalRow("IVA:", iva),
                  const Divider(height: 20, thickness: 1),
                  _buildTotalRow("Total:", total, isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botón de imprimir
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _printInvoice,
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text(
                  "Imprimir Factura",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        Text("C\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isTotal ? Colors.teal : Colors.black87)),
      ],
    );
  }
}
