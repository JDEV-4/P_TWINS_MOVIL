import 'package:flutter/material.dart';
import '../../pages/home_screen.dart';
import '../../pages/user_screen.dart';

class MainLayout extends StatefulWidget {
  final String nombreUsuario;
  final String rolUsuario;
  final String sexoUsuario;

  const MainLayout({
    super.key,
    required this.nombreUsuario,
    required this.rolUsuario,
    required this.sexoUsuario,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ValueNotifier<String> avatarNotifier;

  @override
  void initState() {
    super.initState();
    avatarNotifier = ValueNotifier(_getAvatarPath(widget.sexoUsuario));
  }

  String _getAvatarPath(String sexo) {
    final s = sexo.toUpperCase();
    if (s == 'H') return 'assets/images/Hombre.png';
    if (s == 'M') return 'assets/images/Mujer.png';
    return 'assets/images/Usuario.png';
  }

  List<Widget> get _screens => [
        HomeScreen(
          nombreUsuario: widget.nombreUsuario,
          rolUsuario: widget.rolUsuario,
          sexoUsuario: widget.sexoUsuario,
        ),
        const UsersScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: avatarNotifier,
                builder: (_, path, __) => CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(path),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Text(widget.nombreUsuario,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.rolUsuario,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const Divider(thickness: 1, height: 30),
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
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text('Centro de Control',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        actions: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ValueListenableBuilder<String>(
                valueListenable: avatarNotifier,
                builder: (_, path, __) => CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(path),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
