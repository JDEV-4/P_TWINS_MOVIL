import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    const Color primaryColor = Color(0xFFF55749);
    const Color accentColor = Color(0xFFFDF7F6);
    final String avatarAsset = sexoUsuario.toUpperCase() == 'H'
        ? 'assets/images/Hombre.png'
        : 'assets/images/Mujer.png';

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        leading: Image.asset(asset, width: 36, height: 36, fit: BoxFit.contain),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        onTap: () => _selectSection(section),
      );
    }

    Widget _buildCard(String imageAsset, String title) {
      return GestureDetector(
        onTap: () => _selectSection(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              Image.asset(imageAsset, width: 85, height: 85),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: accentColor,
       drawer: Drawer(
  backgroundColor: Colors.white,
  child: SafeArea(
    child: Column(
      children: [
        // Encabezado compacto
        Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(avatarAsset),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreUsuario,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rolUsuario,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //Lista principal (usamos Expanded + ListView para que el logout quede abajo)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              _drawerItem('assets/images/Productos.png', 'Productos', 'Productos'),
              _drawerItem('assets/images/Categorias.png', 'Categorías', 'Categorías'),
              _drawerItem('assets/images/Ventas.png', 'Ventas', 'Ventas'),
              _drawerItem('assets/images/Usuarios.png', 'Usuarios', 'Usuarios'),
              _drawerItem('assets/images/Reportes.png', 'Reportes', 'Reportes'),
              _drawerItem('assets/images/Ajustes.png', 'Ajustes', 'Ajustes'),
            ],
          ),
        ),

        //Botón de cierrar sesión
        const Divider(height: 1, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Cerrar sesión',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  ),
),


      body: Stack(
        children: [
          // Fondo con gradiente suave
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDECEA), Color(0xFFF8FDFC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Column(
            children: [
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No hay nuevas notificaciones'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => scaffoldKey.currentState?.openDrawer(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white.withOpacity(0.85),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: AssetImage(avatarAsset),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
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
