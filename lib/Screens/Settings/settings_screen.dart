import 'package:Padres360/Screens/Authentication/Repo/logout_repo.dart';
import 'package:flutter/material.dart';

import '../../constants.dart' as AppColors;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _editarPerfil(BuildContext context) {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _contactUs(BuildContext context) {
    Navigator.pushNamed(context, '/contact-us');
  }

  void _cerrarSesion(BuildContext context) {
    // Aquí agregas lógica para cerrar sesión (ej: limpiar tokens, redirigir login)
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            titlePadding: const EdgeInsets.only(top: 16, left: 24, right: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  tooltip: 'Cancelar',
                ),
              ],
            ),
            content: const Text('¿Está seguro que desea cerrar sesión?'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  LogOutRepo.logout(context: context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, index) {
          final items = [
            {
              'icon': Icons.edit,
              'text': 'Perfil',
              'color': AppColors.kMainColor,
              'onTap': () => _editarPerfil(context),
            },
            {
              'icon': Icons.support_agent,
              'text': 'Contáctanos',
              'color': AppColors.kMainColor,
              'onTap': () => _contactUs(context),
            },
            {
              'icon': Icons.logout,
              'text': 'Cerrar sesión',
              'color': AppColors.kErrorColor,
              'onTap': () => _cerrarSesion(context),
            },
          ];

          return ListTile(
            leading: CircleAvatar(
              child: Icon(
                  items[index]['icon'] as IconData, color: items[index]['color'] as Color),
            ),
            title: Text(items[index]['text'] as String),
            onTap: items[index]['onTap'] as void Function(),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
