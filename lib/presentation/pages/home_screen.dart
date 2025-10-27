import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String nombreUsuario;
  final String rolUsuario;
  final String sexoUsuario;

  const HomeScreen({
    super.key,
    required this.nombreUsuario,
    required this.rolUsuario,
    required this.sexoUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF006D65);
    final Color accentColor = const Color(0xFFF1F8F6);
    final Color textColor = const Color(0xFF263238);

    return Container(
      color: accentColor,
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
        children: [
          _buildCard(Icons.inventory_2_outlined, "Productos", primaryColor, textColor),
          _buildCard(Icons.category_outlined, "Categorías", primaryColor, textColor),
          _buildCard(Icons.point_of_sale_outlined, "Ventas", primaryColor, textColor),
          _buildCard(Icons.people_outline, "Usuarios", primaryColor, textColor),
          _buildCard(Icons.bar_chart_outlined, "Reportes", primaryColor, textColor),
          _buildCard(Icons.settings_applications_outlined, "Ajustes", primaryColor, textColor),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color primaryColor, Color textColor) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: primaryColor),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
