import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/pages/producto_screen.dart';

class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Activar animación al construir
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  void _selectSection(String section) {
    // Navegación a ProductoScreen
    if (section == 'Productos') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProductoScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sección seleccionada: $section'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B6B);
    const Color accentColor = Color(0xFFFFF5F5);
    const Color textColor = Color(0xFF333333);

    final String avatarAsset = widget.sexoUsuario.toUpperCase() == 'H'
        ? 'assets/images/Hombre.png'
        : 'assets/images/Mujer.png';

    Widget _drawerItem(String asset, String title, String section) {
      return ListTile(
        leading: Image.asset(asset, width: 32, height: 32, fit: BoxFit.contain),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 15, color: textColor),
        ),
        onTap: () {
          Navigator.pop(context); // Cierra el drawer
          _selectSection(section);
        },
      );
    }

    Widget _buildCard(String imageAsset, String title, int index) {
      return _AnimatedCard(
        delay: 100 * index,
        animate: _animate,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: primaryColor.withOpacity(0.1),
          onTap: () => _selectSection(title),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imageAsset, width: 65, height: 65),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
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
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(avatarAsset),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nombreUsuario,
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
                            widget.rolUsuario,
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
              const Divider(height: 1, color: Colors.grey),
              ListTile(
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF8F8), Color(0xFFFFECEC)],
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                              size: 26,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => scaffoldKey.currentState?.openDrawer(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.white.withOpacity(0.85),
                                child: CircleAvatar(
                                  radius: 21,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1,
                    children: [
                      _buildCard('assets/images/Productos.png', 'Productos', 0),
                      _buildCard('assets/images/Categorias.png', 'Categorías', 1),
                      _buildCard('assets/images/Ventas.png', 'Ventas', 2),
                      _buildCard('assets/images/Usuarios.png', 'Usuarios', 3),
                      _buildCard('assets/images/Reportes.png', 'Reportes', 4),
                      _buildCard('assets/images/Ajustes.png', 'Ajustes', 5),
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

// -----------------------
// Widget para animar las tarjetas
// -----------------------
class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool animate;

  const _AnimatedCard({
    required this.child,
    required this.delay,
    required this.animate,
  });

  @override
  State<_AnimatedCard> createState() => __AnimatedCardState();
}

class __AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double _offsetY = 40;

  @override
  void didUpdateWidget(_AnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && _opacity == 0) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          setState(() {
            _opacity = 1;
            _offsetY = 0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _opacity,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _offsetY, 0),
        child: widget.child,
      ),
    );
  }
}
