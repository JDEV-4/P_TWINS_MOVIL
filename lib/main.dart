import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa para las localizaciones
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/pages/login_screen.dart';
import 'presentation/controllers/compra_controller.dart';
import 'data/http/compra_service.dart';
import 'data/repository/compra_repository_impl.dart';
import 'domain/usecases/crear_compra.dart';

void main() {
  runApp(const PTWINSApp());
}

class PTWINSApp extends StatelessWidget {
  const PTWINSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración del backend
    final compraService = CompraService(baseUrl: 'http://192.168.1.82:5138'); // tu backend
    final compraRepository = CompraRepositoryImpl(service: compraService);
    final crearCompraUseCase = CrearCompra(compraRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CompraController(crearCompraUseCase),
        ),
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
        home: const LoginScreen(),
      ),
    );
  }
}
