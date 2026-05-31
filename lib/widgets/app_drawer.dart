import 'package:app_lince_emp/screens/compras_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';
import '../screens/vendors_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/ventas_screen.dart';
import '../screens/my_products_screen.dart';
import '../screens/reviews_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 120,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.blueGrey),
                    child: Text(
                      'Menú',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),

                // Opción HOME
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Inicio'),
                  selected: currentRoute == 'home',
                  onTap: () {
                    Get.back();
                    if (currentRoute != 'home')
                      Get.offAll(() => const HomeScreen());
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
                        // Solo mostrar si tiene el rol de vendedor (ID 2)
                        if (authController.isVendor) ...[
                          ListTile(
                            leading: const Icon(
                              Icons.inventory_2,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Mis productos'),
                            subtitle: const Text(
                              'Gestionar mi catálogo',
                              style: TextStyle(fontSize: 12),
                            ),
                            selected: currentRoute == 'my_products',
                            onTap: () {
                              Get.back();
                              if (currentRoute != 'my_products') {
                                Get.to(() => MyProductsScreen());
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.storefront,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Mis ventas'),
                            subtitle: const Text(
                              'Pedidos recibidos',
                              style: TextStyle(fontSize: 12),
                            ),
                            selected: currentRoute == 'ventas',
                            onTap: () {
                              Get.back();
                              if (currentRoute != 'ventas') {
                                Get.to(() => const VentasScreen());
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.rate_review,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Reseñas'),
                            subtitle: const Text(
                              'Califica productos y vendedores',
                              style: TextStyle(fontSize: 12),
                            ),
                            selected: currentRoute == 'reviews',
                            onTap: () {
                              Get.back();
                              if (currentRoute != 'reviews')
                                Get.to(() => ReviewsScreen());
                            },
                          ),
                        ],
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
                    if (currentRoute != 'products')
                      Get.to(() => ProductsScreen());
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Colaboradores'),
                  selected: currentRoute == 'vendors',
                  onTap: () {
                    Get.back();
                    if (currentRoute != 'vendors')
                      Get.to(() => VendorsScreen());
                  },
                ),
              ],
            ),
          ),
          // Botón de cerrar sesión al fondo del Drawer
          Obx(
            () => authController.isLoggedIn
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                        title: const Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onTap: () {
                          Get.back();
                          authController.logout();
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
