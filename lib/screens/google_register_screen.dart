// lib/screens/google_register_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class GoogleRegisterScreen extends StatefulWidget {
  const GoogleRegisterScreen({Key? key}) : super(key: key);

  @override
  State<GoogleRegisterScreen> createState() => _GoogleRegisterScreenState();
}

class _GoogleRegisterScreenState extends State<GoogleRegisterScreen> {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController careerController = TextEditingController();
  bool isVendor = false;

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario de Google guardado temporalmente en el controlador
    final googleUser = authController.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Completar Perfil Lince'), elevation: 0),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Feedback visual de que reconocimos su cuenta de Google
              CircleAvatar(
                radius: 40,
                backgroundImage: googleUser?.photoUrl != null
                    ? NetworkImage(googleUser!.photoUrl!)
                    : null,
                child: googleUser?.photoUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                '¡Hola, ${googleUser?.displayName ?? "Usuario"}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${googleUser?.email}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                'Para terminar la creación de tu cuenta, por favor ingresa los siguientes datos:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Inputs Únicamente necesarios
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: careerController,
                decoration: InputDecoration(
                  labelText: 'Carrera',
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Selector de Rol (Vendedor / Cliente)
              SwitchListTile(
                title: const Text("¿Quieres vender productos?"),
                subtitle: Text(
                  isVendor ? "Rol Vendedor asignado" : "Solo Cliente",
                ),
                value: isVendor,
                onChanged: (val) {
                  setState(() {
                    isVendor = val;
                  });
                },
                activeColor: Colors.blueGrey,
              ),
              const SizedBox(height: 30),

              // Botón Finalizar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => authController.registerGoogleUser(
                    telefono: phoneController.text,
                    carrera: careerController.text,
                    isVendor: isVendor,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Finalizar Registro',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
