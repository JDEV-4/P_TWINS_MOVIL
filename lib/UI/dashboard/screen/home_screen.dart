import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF006D65);
  final Color accentColor = const Color(0xFFE8F5E9);
  final Color secondaryColor = const Color(0xFF4DB6AC);
  final Color textColor = const Color(0xFF37474F);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- Cantidad de notificaciones ---
  int notificationCount = 2; // Podés cambiarlo dinámicamente más adelante

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: accentColor,

      // --- Drawer (menú lateral) ---
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: const Color(0xFF004D40),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage('assets/images/Hombre.png'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Javier Dávila',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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

            // --- Opciones scrollables ---
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDrawerItem(icon: Icons.home, text: 'Inicio', onTap: () => Navigator.pop(context)),
                      _buildDrawerItem(icon: Icons.person, text: 'Perfil', onTap: () {}),
                      _buildDrawerItem(icon: Icons.settings, text: 'Configuración', onTap: () {}),
                      _buildDrawerItem(icon: Icons.info_outline, text: 'Acerca de', onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),

            // --- Cerrar sesión ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: _buildDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Cerrar sesión',
                onTap: () {
                  Navigator.pop(context);
                  // Lógica de logout
                },
              ),
            ),
          ],
        ),
      ),

      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Centro de Control",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          // --- Botón de notificaciones ---
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No tienes notificaciones nuevas")),
                  );
                  setState(() {
                    notificationCount = 0; // Limpia notificaciones al abrir
                  });
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // --- Avatar del usuario (abre el Drawer) ---
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: Hero(
                tag: 'userAvatar',
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage('assets/images/Hombre.png'),
                ),
              ),
            ),
          ),
        ],
      ),

      // --- Contenido principal ---
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          children: [
            _buildCard(Icons.inventory_2_outlined, "Productos"),
            _buildCard(Icons.category_outlined, "Categorías"),
            _buildCard(Icons.point_of_sale_outlined, "Ventas"),
            _buildCard(Icons.people_outlined, "Usuarios"),
            _buildCard(Icons.bar_chart_outlined, "Reportes"),
            _buildCard(Icons.settings_applications_outlined, "Ajustes"),
          ],
        ),
      ),
    );
  }

  // --- Tarjetas del menú principal ---
  Widget _buildCard(IconData icon, String title) {
    return GestureDetector(
      onTap: () => print('Navegando a: $title'),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 40, color: primaryColor),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Items del Drawer ---
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 16)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
