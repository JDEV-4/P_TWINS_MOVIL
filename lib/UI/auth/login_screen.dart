import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
  color: Colors.white, // Fondo blanco o cambia a Color(0xFFF5F5F5) si querés gris suave
),


        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono superior
                  const Icon(
                    Icons.account_circle,
                    size: 120,
                    color: Color(0xFF1A6B6B),
                  ),
                  const SizedBox(height: 25),

                  // Texto principal
                  const Text(
                    'Bienvenido de nuevo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A6B6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia sesión para continuar',
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value!),
                        activeColor: const Color(0xFF1A6B6B),
                      ),
                      const Text('Recuérdame'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Botón de inicio de sesión
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
                        // TODO: Conectar con backend (ASP.NET Core)
                      },
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: '¿No estás registrado? ',
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Regístrate',
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
