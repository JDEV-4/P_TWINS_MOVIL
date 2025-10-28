import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../../data/http/api_service.dart';

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
    final String usuario = _usuarioController.text.trim();
    final String clave = _passwordController.text.trim();

    if (usuario.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    ApiService api = ApiService();
    final result = await api.login(usuario, clave);

    setState(() => _isLoading = false);

    if (result['success']) {
      await api.saveToken(result['token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            nombreUsuario: result['usuario'],
            rolUsuario: result['rol'],
            sexoUsuario: result['sexo'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color kBotonColor = Color(0xFFFE6F61);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(
            'assets/images/Fondo.png',
            fit: BoxFit.cover,
          ),

          // Círculos decorativos
          Positioned(
            top: -50,
            left: -50,
            child: _circleDecoration(150, Colors.white.withOpacity(0.15)),
          ),
          Positioned(
            top: 100,
            right: -40,
            child: _circleDecoration(120, Colors.white.withOpacity(0.10)),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: _circleDecoration(180, Colors.white.withOpacity(0.12)),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _circleDecoration(220, Colors.white.withOpacity(0.08)),
          ),

          // Contenido
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.bottom > 0 ? 80 : 210,
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
                        // Card
                        Container(
                          padding: const EdgeInsets.fromLTRB(28, 64, 28, 28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: Colors.white.withOpacity(0.85), //blanca
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Bienvenido",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                              _buildTextField(
                                controller: _usuarioController,
                                label: "Usuario",
                                icon: Icons.person,
                                color: kBotonColor,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _passwordController,
                                label: "Contraseña",
                                icon: Icons.lock,
                                color: kBotonColor,
                                obscure: true,
                              ),
                              const SizedBox(height: 32),
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
                                          backgroundColor: kBotonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 6,
                                          shadowColor:
                                              kBotonColor.withOpacity(0.3),
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
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Olvidé mi contraseña",
                                  style: TextStyle(
                                    color: kBotonColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Icono superior
                        Positioned(
                          top: -44,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 56,
                                color: kBotonColor,
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

  Widget _circleDecoration(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
