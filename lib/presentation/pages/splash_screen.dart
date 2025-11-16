import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    await Future.delayed(const Duration(milliseconds: 400)); // animación opcional

    // SI NO HAY TOKEN → LOGIN
    if (token == null || token.isEmpty) {
      _goToLogin();
      return;
    }

    // SI HAY TOKEN → verificamos si expiró
    bool isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      // token expiró → borrar y mandar a login
      await prefs.remove('token');
      _goToLogin();
    } else {
      // token válido → HomeScreen
      _goToHome();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(
          nombreUsuario: 'Cargando...',
          rolUsuario: 'Usuario',
          sexoUsuario: 'H',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
