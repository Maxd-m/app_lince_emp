// lib/screens/profile_screen.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos el controlador que ya fue instanciado
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blueGrey,
      ),
      // === MENÚ LATERAL (HAMBURGUESA) ===
      drawer: const AppDrawer(currentRoute: 'profile'),

      body: Center(
        child: Obx(() {
          if (!authController.isLoggedIn) {
            return const Text('No has iniciado sesión.');
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: authController.displayPhoto != null
                    ? NetworkImage(authController.displayPhoto!)
                    : null,
                child: authController.displayPhoto == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                authController.displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                authController.displayEmail,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              if (authController.roles.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: authController.roles.map((rol) {
                    return Chip(
                      label: Text(rol['nombre'].toString().toUpperCase()),
                      backgroundColor: Colors.blueGrey.shade100,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  await authController.logout();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
