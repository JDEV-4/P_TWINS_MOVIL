import 'package:flutter/material.dart';
import 'Invoice_Screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final Color primaryColor = const Color(0xFF00BFA5);
  final Color accentColor = const Color(0xFFE0F7FA);
  final TextEditingController searchController = TextEditingController();
  final TextEditingController clientController = TextEditingController();

  final String currentUser = "Javier Dávila";
  final DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>> products = [
    {"name": "Eskimo Clásico", "price": 25.0},
    {"name": "Cono de Vainilla", "price": 30.0},
    {"name": "Cono de Chocolate", "price": 30.0},
    {"name": "Paleta Fresa", "price": 20.0},
    {"name": "Sundae Mixto", "price": 45.0},
    {"name": "Sándwich de Helado", "price": 35.0},
    {"name": "Banana Split", "price": 50.0},
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      var existing = cart.firstWhere(
        (item) => item["name"] == product["name"],
        orElse: () => {},
      );
      if (existing.isNotEmpty) {
        existing["quantity"]++;
      } else {
        cart.add({"name": product["name"], "price": product["price"], "quantity": 1});
      }
    });
  }

  void removeFromCart(Map<String, dynamic> product) {
    setState(() {
      var existing = cart.firstWhere(
        (item) => item["name"] == product["name"],
        orElse: () => {},
      );
      if (existing.isNotEmpty) {
        if (existing["quantity"] > 1) {
          existing["quantity"]--;
        } else {
          cart.remove(existing);
        }
      }
    });
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products
            .where((p) => p["name"].toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
    });
  }

  double get subtotal => cart.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));
  double get iva => subtotal * 0.15;
  double get totalWithIva => subtotal + iva;

  void showCustomSnackBar(String message, IconData icon, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void registerSale() {
    if (clientController.text.isEmpty) {
      showCustomSnackBar(
        "Debes agregar el nombre del cliente.",
        Icons.warning_amber_rounded,
        Colors.orangeAccent,
      );
      return;
    }

    if (cart.isEmpty) {
      showCustomSnackBar(
        "Debes agregar productos antes de registrar la venta.",
        Icons.warning_amber_rounded,
        Colors.orangeAccent,
      );
      return;
    }

    final cartCopy = List<Map<String, dynamic>>.from(cart);
    final String clientName = clientController.text;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                "¿Deseas imprimir la factura?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Puedes ver la factura antes de finalizar la venta.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showCustomSnackBar("Venta cancelada.", Icons.cancel, Colors.grey);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("No",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(
                            cart: cartCopy,
                            clientName: clientName,
                            seller: currentUser,
                            date: currentDate,
                          ),
                        ),
                      ).then((_) {
                        setState(() {
                          cart.clear();
                          clientController.clear();
                        });
                      });

                      showCustomSnackBar(
                        "¡Venta registrada con éxito!",
                        Icons.check_circle_outline,
                        primaryColor,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("Sí",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
  backgroundColor: primaryColor,
  title: const Text(
    "Paletitas Twins",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // PRODUCTOS DISPONIBLES
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Productos Disponibles",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar producto...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: accentColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      onChanged: filterProducts,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? Center(
                              child: Text(
                                "No se encontraron productos...",
                                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final p = filteredProducts[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    title: Text(p["name"], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                    subtitle: Text("C\$${p['price'].toStringAsFixed(2)}",
                                        style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500)),
                                    trailing: IconButton(
                                        icon: Icon(Icons.add_shopping_cart, color: primaryColor),
                                        onPressed: () => addToCart(p)),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // CARRITO DE COMPRAS
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Carrito de Compras", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 8),
                    // Cliente
                    TextField(
                      controller: clientController,
                      decoration: InputDecoration(
                        labelText: "Cliente",
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: accentColor,
                      ),
                    ),
                    const Divider(),
                    // Lista de productos en carrito
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item["name"], style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text(
                                        "C\$${item['price']} x ${item['quantity']} = C\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(icon: const Icon(Icons.remove_circle, color: Colors.redAccent), onPressed: () => removeFromCart(item)),
                                    Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(icon: Icon(Icons.add_circle, color: primaryColor), onPressed: () => addToCart(item)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    // Totales
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("C\$${subtotal.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("IVA:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("C\$${iva.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("C\$${totalWithIva.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: registerSale,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        label: const Text("Registrar Venta",
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
