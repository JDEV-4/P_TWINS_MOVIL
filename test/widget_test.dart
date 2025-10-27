import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twins/main.dart'; 
import 'package:twins/presentation/pages/login_screen.dart';
import 'package:twins/presentation/widgets/organisms/main_layout.dart';

void main() {
  testWidgets('LoginScreen displays correctly', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const PTWINSApp());

    // Verificar que el LoginScreen aparece
    expect(find.byType(LoginScreen), findsOneWidget);

    // Verificar campos de texto
    expect(find.byType(TextField), findsNWidgets(2)); // Usuario y Contraseña

    // Verificar botón de login
    expect(find.text('Iniciar sesión'), findsOneWidget);

    // Simular ingreso de credenciales válidas
    await tester.enterText(find.byType(TextField).first, 'admin'); // Usuario
    await tester.enterText(find.byType(TextField).last, '1234'); // Contraseña

    // Tap en el botón
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(); // reconstruye el widget

    // Esperar la duración simulada del login
    await tester.pump(const Duration(seconds: 2));

    // Verificar que se navega a MainLayout
    expect(find.byType(MainLayout), findsOneWidget);
  });
}
