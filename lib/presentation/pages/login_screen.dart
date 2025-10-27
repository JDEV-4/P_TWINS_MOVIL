import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color kPrimario = Color(0xFF1A676F);
    const Color kTextoGris = Color(0xFF37474F);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con círculos decorativos
          Container(color: const Color(0xFFECEFF1)),
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // Contenido con desplazamiento y animación al abrir el teclado
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.bottom > 0 ? 80 : 180,
                bottom: 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 360,
                      minWidth: 280,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Tarjeta principal
                        Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(28),
                          shadowColor: Colors.black26,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(28, 64, 28, 28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Bienvenido",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: kTextoGris,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Inicia sesión para continuar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Campo usuario
                                _buildTextField(
                                  controller: _usuarioController,
                                  label: "Usuario",
                                  icon: Icons.person,
                                  color: kPrimario,
                                ),
                                const SizedBox(height: 20),

                                // Campo contraseña
                                _buildTextField(
                                  controller: _passwordController,
                                  label: "Contraseña",
                                  icon: Icons.lock,
                                  color: kPrimario,
                                  obscure: true,
                                ),
                                const SizedBox(height: 32),

                                // Botón de inicio de sesión
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ElevatedButton(
                                          onPressed: _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimario,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 6,
                                            shadowColor:
                                                kPrimario.withOpacity(0.3),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Iniciar sesión",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 16),

                                // Enlace de recuperación
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Olvidé mi contraseña",
                                    style: TextStyle(color: kPrimario),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Avatar flotante
                        Positioned(
                          top: -44,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [kPrimario, kPrimario.withOpacity(0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimario.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 56,
                                color: kPrimario.withOpacity(0.85),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Constructor de los TextFields personalizados
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool obscure = false,
  }) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: color.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: color, width: 1.5),
          ),
        ),
      ),
    );
  }
}
