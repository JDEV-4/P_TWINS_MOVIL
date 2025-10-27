import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/pages/login_screen.dart';

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
      theme: ThemeData(
        fontFamily: 'NotoSans',
        primaryColor: const Color(0xFF1A6B6B),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A6B6B)),
      ),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
    );
  }
}
