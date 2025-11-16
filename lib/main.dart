import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/pages/splash_screen.dart';


// ===== Ejemplo de Provider simple =====
class UsuarioProvider extends ChangeNotifier {
  String _nombre = '';

  String get nombre => _nombre;

  void setNombre(String nuevoNombre) {
    _nombre = nuevoNombre;
    notifyListeners();
  }
}

// ===== Aplicación principal =====
void main() {
  runApp(const PTWINSApp());
}

class PTWINSApp extends StatelessWidget {
  const PTWINSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ],
      child: MaterialApp(
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const SplashScreen(),
      ),
    );
  }
}
