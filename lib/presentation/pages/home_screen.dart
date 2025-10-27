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

    final String avatarAsset = sexoUsuario.toUpperCase() == 'H'
        ? 'assets/images/Hombre.png'
        : 'assets/images/Mujer.png';

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    void _selectSection(String section) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sección seleccionada: $section'),
          duration: const Duration(seconds: 1),
        ),
      );
    }

    Widget _drawerItem(String asset, String title, String section) {
      return ListTile(
        leading: Image.asset(
          asset,
          width: 100,  // antes 24
          height: 100, 
          fit: BoxFit.contain,
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: () => _selectSection(section),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: accentColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(avatarAsset),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nombreUsuario,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    rolUsuario,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _drawerItem('assets/images/Productos.png', 'Productos', 'Productos'),
            _drawerItem('assets/images/Categorias.png', 'Categorías', 'Categorías'),
            _drawerItem('assets/images/Ventas.png', 'Ventas', 'Ventas'),
            _drawerItem('assets/images/Usuarios.png', 'Usuarios', 'Usuarios'),
            _drawerItem('assets/images/Reportes.png', 'Reportes', 'Reportes'),
            _drawerItem('assets/images/Ajustes.png', 'Ajustes', 'Ajustes'),
          ],
        ),
      ),
      body: Column(
        children: [
          // HEADER CON "Dashboard", AVATAR Y CAMPANA
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Dashboard',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No hay nuevas notificaciones'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 23,
                          backgroundImage: AssetImage(avatarAsset),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // GRID DE TARJETAS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _buildCardImage('assets/images/Productos.png'),
                  _buildCardImage('assets/images/Categorias.png'),
                  _buildCardImage('assets/images/Ventas.png'),
                  _buildCardImage('assets/images/Usuarios.png'),
                  _buildCardImage('assets/images/Reportes.png'),
                  _buildCardImage('assets/images/Ajustes.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage(String imageAsset) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imageAsset,
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
