import 'package:flutter/material.dart';
import 'ui/auth/login_screen.dart';

void main() {
  runApp(const PTWINSApp());
}

class PTWINSApp extends StatelessWidget {
  const PTWINSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTWINS',
      home: const LoginScreen(),
    );
  }
}
