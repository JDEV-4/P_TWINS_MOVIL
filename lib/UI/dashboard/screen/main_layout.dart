import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'usersScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  int _notificationCount = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const UsersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Cierra el Drawer al seleccionar
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // --- Avatar principal en el Drawer ---
              CircleAvatar(
                radius: 45,
                backgroundImage: const AssetImage('assets/avatar.png'),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 10),
              const Text(
                'Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1, height: 30),
              
              // --- Opciones del Drawer ---
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Centro de control'),
                selected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Usuarios'),
                selected: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),

              const Spacer(),
              const Divider(),
              // --- Botón de cerrar sesión ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    // Aquí puedes poner la lógica de logout
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Centro de Control',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          // --- Notificaciones (campanita) ---
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                onPressed: () {
                  // Aquí puedes abrir el módulo de notificaciones
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          // --- Avatar en AppBar (abre el Drawer) ---
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
          ),
        ],
      ),

      body: _screens[_selectedIndex],
    );
  }
}
