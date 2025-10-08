import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final Color primaryColor = const Color(0xFF006D65);
  final Color accentColor = const Color(0xFFE8F5E9);
  final Color secondaryColor = const Color(0xFF4DB6AC);
  final Color textColor = const Color(0xFF37474F);
  final Color activeColor = const Color(0xFF81C784);
  final Color inactiveColor = const Color(0xFFE57373);
  final Color editColor = const Color(0xFF64B5F6);

  List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'name': 'Javier Dávila',
      'username': 'admin',
      'email': 'javier@email.com',
      'password': '1234',
      'role': 'Administrador',
      'active': true
    },
    {
      'id': 2,
      'name': 'Ana López',
      'username': 'ana',
      'email': 'ana@email.com',
      'password': 'abcdef',
      'role': 'Invitado',
      'active': true
    },
    {
      'id': 3,
      'name': 'Carlos Pérez',
      'username': 'carlos',
      'email': 'carlos@email.com',
      'password': 'qwerty',
      'role': 'Invitado',
      'active': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor:
                      user['active'] ? activeColor : inactiveColor,
                  child: Text(
                    user['name'][0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  user['name'],
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  user['role'] ?? 'Invitado',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        user['active'] ? Icons.check_circle : Icons.cancel,
                        color: user['active'] ? activeColor : inactiveColor,
                      ),
                      onPressed: () {
                        setState(() {
                          users[index]['active'] = !users[index]['active'];
                        });
                      },
                      tooltip: user['active']
                          ? 'Desactivar usuario'
                          : 'Activar usuario',
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: editColor),
                      onPressed: () {
                        _showEditDialog(index);
                      },
                      tooltip: 'Editar usuario',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: _showAddDialog,
        tooltip: 'Nuevo usuario',
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: secondaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  void _showEditDialog(int index) {
    final nameController = TextEditingController(text: users[index]['name']);
    final usernameController =
        TextEditingController(text: users[index]['username']);
    final emailController = TextEditingController(text: users[index]['email']);
    final passwordController =
        TextEditingController(text: users[index]['password']);
    String selectedRole = users[index]['role'] ?? 'Invitado';

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Editar Usuario',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                    controller: nameController,
                    decoration: _inputDecoration('Nombre', Icons.person)),
                const SizedBox(height: 12),
                TextField(
                    controller: usernameController,
                    decoration:
                        _inputDecoration('Usuario', Icons.account_circle)),
                const SizedBox(height: 12),
                TextField(
                    controller: emailController,
                    decoration: _inputDecoration('Email', Icons.email)),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:
                      _inputDecoration('Contraseña', Icons.lock_outline),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: _inputDecoration('Rol', Icons.work_outline),
                  items: ['Administrador', 'Invitado']
                      .map((role) =>
                          DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedRole = value;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: textColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          users[index]['name'] = nameController.text;
                          users[index]['username'] = usernameController.text;
                          users[index]['email'] = emailController.text;
                          users[index]['password'] = passwordController.text;
                          users[index]['role'] = selectedRole;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usuario actualizado con éxito'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                      child: const Text('Guardar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Modal para agregar usuario
  void _showAddDialog() {
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'Administrador';

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Agregar Usuario',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                    controller: nameController,
                    decoration: _inputDecoration('Nombre', Icons.person)),
                const SizedBox(height: 12),
                TextField(
                    controller: usernameController,
                    decoration:
                        _inputDecoration('Usuario', Icons.account_circle)),
                const SizedBox(height: 12),
                TextField(
                    controller: emailController,
                    decoration: _inputDecoration('Email', Icons.email)),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:
                      _inputDecoration('Contraseña', Icons.lock_outline),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: _inputDecoration('Rol', Icons.work_outline),
                  items: ['Administrador', 'Invitado']
                      .map((role) =>
                          DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedRole = value;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: textColor),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, completa todos los campos'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          users.add({
                            'id': users.length + 1,
                            'name': nameController.text,
                            'username': usernameController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                            'role': selectedRole,
                            'active': true,
                          });
                        });
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usuario agregado con éxito'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                      child: const Text('Agregar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
