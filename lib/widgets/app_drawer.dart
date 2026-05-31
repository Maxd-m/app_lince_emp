import 'package:app_lince_emp/screens/compras_screen.dart';
import 'package:app_lince_emp/screens/login_screen.dart';
import 'package:app_lince_emp/screens/my_products_screen.dart';
import 'package:app_lince_emp/screens/products_screen.dart';
import 'package:app_lince_emp/screens/profile_screen.dart';
import 'package:app_lince_emp/screens/reviews_screen.dart';
import 'package:app_lince_emp/screens/vendors_screen.dart';
import 'package:app_lince_emp/screens/ventas_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import '../controllers/auth_controller.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatefulWidget {
  final String currentRoute;
  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final GlobalKey _keyHome = GlobalKey();
  final GlobalKey _keyProfile = GlobalKey();
  final GlobalKey _keyProducts = GlobalKey();
  final GlobalKey _keyVendors = GlobalKey();
  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Disparamos el tutorial después de que el Drawer se renderice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool hasSeenTutorial =
          _storage.read('hasSeenDrawerTutorial') ?? false;
      if (!hasSeenTutorial) {
        final AuthController authController = Get.find<AuthController>();

        // Creamos la lista de llaves a mostrar (solo las que existen en pantalla)
        List<GlobalKey> keys = [_keyHome];
        if (authController.isLoggedIn) keys.add(_keyProfile);
        keys.add(_keyProducts);
        keys.add(_keyVendors);

        // ignore: deprecated_member_use
        ShowCaseWidget.of(context).startShowCase(keys);
        _storage.write('hasSeenDrawerTutorial', true);
      }
    });
  }

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
                Showcase(
                  key: _keyHome,
                  title: 'Inicio',
                  description: 'Vuelve a la pantalla principal rápidamente.',
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    selected: widget.currentRoute == 'home',
                    onTap: () {
                      Get.back();
                      if (widget.currentRoute != 'home')
                        Get.offAll(() => const HomeScreen());
                    },
                  ),
                ),

                Obx(() {
                  if (authController.isLoggedIn) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Showcase(
                          key: _keyProfile,
                          title: 'Mi Perfil',
                          description:
                              'Aquí puedes ver tus permisos y cerrar sesión.',
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Mi Perfil'),
                            subtitle: Text(
                              authController.displayEmail,
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: widget.currentRoute == 'profile',
                            onTap: () {
                              Get.back();
                              if (widget.currentRoute != 'profile')
                                Get.to(() => const ProfileScreen());
                            },
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('Mis compras'),
                          subtitle: const Text(
                            'Historial de pedidos',
                            style: TextStyle(fontSize: 12),
                          ),
                          selected: widget.currentRoute == 'compras',
                          onTap: () {
                            Get.back();
                            if (widget.currentRoute != 'compras')
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
                            selected: widget.currentRoute == 'my_products',
                            onTap: () {
                              Get.back();
                              if (widget.currentRoute != 'my_products') {
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
                            selected: widget.currentRoute == 'ventas',
                            onTap: () {
                              Get.back();
                              if (widget.currentRoute != 'ventas') {
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
                            selected: widget.currentRoute == 'reviews',
                            onTap: () {
                              Get.back();
                              if (widget.currentRoute != 'reviews')
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

                Showcase(
                  key: _keyProducts,
                  title: 'Catálogo',
                  description:
                      'Explora todos los productos disponibles en la plataforma.',
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: const Text('Productos'),
                    selected: widget.currentRoute == 'products',
                    onTap: () {
                      Get.back();
                      if (widget.currentRoute != 'products')
                        Get.to(() => ProductsScreen());
                    },
                  ),
                ),

                Showcase(
                  key: _keyVendors,
                  title: 'Colaboradores',
                  description:
                      'Conoce a los vendedores destacados de la comunidad.',
                  child: ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Colaboradores'),
                    selected: widget.currentRoute == 'vendors',
                    onTap: () {
                      Get.back();
                      if (widget.currentRoute != 'vendors')
                        Get.to(() => VendorsScreen());
                    },
                  ),
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
