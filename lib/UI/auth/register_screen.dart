import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Fondo igual al login
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono superior igual que en login
                  const Icon(
                    Icons.app_registration_rounded,
                    size: 120,
                    color: Color(0xFF1A6B6B),
                  ),
                  const SizedBox(height: 25),

                  // Título principal
                  const Text(
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A6B6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Regístrate para continuar',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Campos de texto
                  CustomTextField(hintText: 'Usuario', controller: _userController),
                  CustomTextField(
                    hintText: 'Contraseña',
                    obscureText: true,
                    controller: _passController,
                  ),
                  CustomTextField(
                    hintText: 'Confirmar contraseña',
                    obscureText: true,
                    controller: _confirmPassController,
                  ),

                  const SizedBox(height: 20),

                  // Botón de registro con mismo estilo que login
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6B6B),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Agregar lógica de registro con backend
                      },
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Texto para volver al login
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Inicia sesión',
                            style: TextStyle(
                              color: Color(0xFF1A6B6B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
