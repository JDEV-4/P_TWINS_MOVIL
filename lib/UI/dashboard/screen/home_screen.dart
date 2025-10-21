import 'package:flutter/material.dart';
import 'usersScreen.dart';
import 'sales_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF006D65);
  final Color accentColor = const Color(0xFFF1F8F6);
  final Color secondaryColor = const Color(0xFF26A69A);
  final Color textColor = const Color(0xFF263238);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int notificationCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: accentColor,

      // ===== Drawer =====
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        const AssetImage('assets/images/Hombre.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Javier Dávila',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Administrador',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // ===== Opciones del Drawer =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _buildDrawerItem(Icons.home, "Inicio",
                      () => Navigator.pop(context)),
                  _buildDrawerItem(Icons.person_outline, "Perfil", () {}),
                  _buildDrawerItem(Icons.settings_outlined, "Configuración", () {}),
                  _buildDrawerItem(Icons.info_outline, "Acerca de", () {}),
                ],
              ),
            ),

            // ===== Cerrar Sesión =====
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Lógica para cerrar sesión
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== AppBar =====
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Centro de Control",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          // --- Notificaciones ---
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No tienes notificaciones nuevas")),
              );
            },
          ),

          // --- Avatar del usuario (abre el Drawer) ---
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/Hombre.png'),
              ),
            ),
          ),
        ],
      ),

      // ===== Contenido principal =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildCard(Icons.inventory_2_outlined, "Productos"),
            _buildCard(Icons.category_outlined, "Categorías"),
            _buildCard(Icons.point_of_sale_outlined, "Ventas"),
            _buildCard(Icons.people_outline, "Usuarios"),
            _buildCard(Icons.bar_chart_outlined, "Reportes"),
            _buildCard(Icons.settings_applications_outlined, "Ajustes"),
          ],
        ),
      ),
    );
  }

  // ===== Tarjetas del menú principal =====
  Widget _buildCard(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Usuarios") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsersScreen()),
          );
        } else if (title == "Ventas") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SalesScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("La opción '$title' aún no está disponible.")),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Elemento del Drawer =====
  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
      hoverColor: accentColor,
    );
  }
}
