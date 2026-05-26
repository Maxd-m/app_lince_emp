import 'package:app_lince_emp/screens/compras_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';
import '../screens/vendors_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Drawer(
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

          // Opción HOME
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: currentRoute == 'home',
            onTap: () {
              Get.back();
              if (currentRoute != 'home') Get.offAll(() => const HomeScreen());
            },
          ),

          Obx(() {
            if (authController.isLoggedIn) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Mi Perfil'),
                    subtitle: Text(
                      authController.displayEmail,
                      style: const TextStyle(fontSize: 12),
                    ),
                    selected: currentRoute == 'profile',
                    onTap: () {
                      Get.back();
                      if (currentRoute != 'profile')
                        Get.to(() => const ProfileScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Mis compras'),
                    subtitle: const Text(
                      'Historial de pedidos',
                      style: TextStyle(fontSize: 12),
                    ),
                    selected: currentRoute == 'compras',
                    onTap: () {
                      Get.back();
                      if (currentRoute != 'compras')
                        Get.to(() => const ComprasScreen());
                    },
                  ),
                ],
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar sesión'),
                onTap: () {
                  Get.back();
                  Get.to(() => LoginScreen());
                },
              );
            }
          }),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Productos'),
            selected: currentRoute == 'products',
            onTap: () {
              Get.back();
              if (currentRoute != 'products') Get.to(() => ProductsScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Colaboradores'),
            selected: currentRoute == 'vendors',
            onTap: () {
              Get.back();
              if (currentRoute != 'vendors') Get.to(() => VendorsScreen());
            },
          ),
        ],
      ),
    );
  }
}
