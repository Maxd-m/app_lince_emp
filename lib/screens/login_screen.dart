// lib/screens/login_screen.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Instanciamos e inyectamos el controlador en el ecosistema de GetX
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Google Auth con GetX'), elevation: 0),

      body: Center(
        // Obx reconstruye automáticamente este widget cuando cambian currentUser o isLoading
        child: Obx(() {
          // 1. Estado de carga
          if (authController.isLoading.value) {
            return const CircularProgressIndicator();
          }

          // 2. Estado: Usuario autenticado (Dashboard temporal)
          if (authController.currentUser.value != null) {
            final user = authController.currentUser.value!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  '¡Bienvenido, ${user.displayName}!',
                  style: const TextStyle(
                    fontSize: 22,
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
                  onPressed: authController.logout,
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
          }

          // 3. Estado: Usuario NO autenticado (Botón de login)
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Ingresa a tu cuenta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: // Reemplaza el bloque del botón en lib/screens/login_screen.dart con esto:
                  ElevatedButton.icon(
                    onPressed: authController.login,
                    // Cambiamos a un PNG válido que Flutter sí puede renderizar
                    icon: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                      height: 24,
                    ),
                    label: const Text(
                      'Continuar con Google',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
