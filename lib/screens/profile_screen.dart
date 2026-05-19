// lib/screens/profile_screen.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Home'),
              onTap: () {
                Get.off(() => const HomeScreen());
                // TODO: Navegar a pantalla de productos
              },
            ),

            // ===========================================
            const Divider(), // Agregamos una línea divisoria por estética

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Productos'),
              onTap: () {
                Get.back();
                // TODO: Navegar a pantalla de productos
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Colaboradores'),
              onTap: () {
                Get.back();
                // TODO: Navegar a pantalla de colaboradores
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Obx(() {
          final user = authController.currentUser.value;

          // Por seguridad, si el usuario es nulo, mostramos un mensaje
          if (user == null) {
            return const Text('No has iniciado sesión.');
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                user.displayName ?? 'Usuario',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
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
