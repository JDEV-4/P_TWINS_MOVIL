import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/pages/producto_screen.dart';
import '../../presentation/pages/compra_screen.dart';
import '../../data/http/api_service.dart';
import '../pages/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String nombreUsuario;
  final String rolUsuario; // Ej: "1" o "2"
  final String sexoUsuario; // "H" o "M"

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
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  // Convierte el rol a un texto amigable
  String getRolTexto(String rol) {
    switch (rol.toLowerCase()) {
      case 'vendedor':
      case '1':
        return 'Vendedor';
      case 'administrador':
      case '2':
        return 'Administrador';
      default:
        return 'Usuario';
    }
  }

  void _selectSection(String section) {
    if (section == 'Productos') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProductoScreen()),
      );
    } else if (section == 'Compras') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompraScreen(nombreUsuario: widget.nombreUsuario),
        ),
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

  void _abrirPerfil() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final rolTexto = getRolTexto(widget.rolUsuario);
        final avatarAsset = widget.sexoUsuario.toUpperCase() == 'H'
            ? 'assets/images/Hombre.png'
            : 'assets/images/Mujer.png';

        return Padding(
          padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(avatarAsset),
              ),
              const SizedBox(height: 16),
              Text(widget.nombreUsuario,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(rolTexto, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Limpiar token o datos de sesión
                    await ApiService().logout();

                    // Cierra el modal
                    Navigator.pop(context);

                    // Navegar a Login y reemplazar historial
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B81),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: const Text("Cerrar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B81);
    const Color accentColor = Color(0xFFFFF8F8);
    const Color textColor = Color(0xFF333333);

    final String avatarAsset = widget.sexoUsuario.toUpperCase() == 'H'
        ? 'assets/images/Hombre.png'
        : 'assets/images/Mujer.png';

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
      backgroundColor: accentColor,
      body: Column(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: const BoxDecoration(
                color: primaryColor,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: GestureDetector(
                          onTap: _abrirPerfil,
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
                  _buildCard('assets/images/Compra.png', 'Compras', 5),
                ],
              ),
            ),
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
