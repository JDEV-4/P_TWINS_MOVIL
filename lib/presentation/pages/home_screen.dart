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
    const Color primaryColor = Color.fromARGB(255, 245, 87, 73);
    const Color accentColor = Color(0xFFF1F8F6);

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
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        title: Text(title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            )),
        onTap: () => _selectSection(section),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
    }

    Widget _buildCard(String imageAsset, String title) {
      return GestureDetector(
        onTap: () {},
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: 1.0),
          duration: const Duration(milliseconds: 200),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAsset,
                  width: 90, // aumentamos tamaño
                  height: 90, // aumentamos tamaño
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _circleDecoration(double size, Color color) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: accentColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
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
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rolUsuario,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Círculos decorativos
          Positioned(top: -50, left: -50, child: _circleDecoration(150, Colors.white.withOpacity(0.15))),
          Positioned(top: 100, right: -40, child: _circleDecoration(120, Colors.white.withOpacity(0.10))),
          Positioned(bottom: -60, left: -30, child: _circleDecoration(180, Colors.white.withOpacity(0.12))),
          Positioned(bottom: -80, right: -60, child: _circleDecoration(220, Colors.white.withOpacity(0.08))),

          Column(
            children: [
              // HEADER
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
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
                                color: Colors.black26.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white.withOpacity(0.85),
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
                      _buildCard('assets/images/Productos.png', 'Productos'),
                      _buildCard('assets/images/Categorias.png', 'Categorías'),
                      _buildCard('assets/images/Ventas.png', 'Ventas'),
                      _buildCard('assets/images/Usuarios.png', 'Usuarios'),
                      _buildCard('assets/images/Reportes.png', 'Reportes'),
                      _buildCard('assets/images/Ajustes.png', 'Ajustes'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
