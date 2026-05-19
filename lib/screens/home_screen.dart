// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/vendor_card.dart';
import '../models/product_model.dart';
import '../models/vendor_model.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../api/product_api.dart'; // Solo usado para importar el mock
import '../api/vendor_api.dart'; // Solo usado para importar el mock

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controlador. Usamos Get.put para asegurarnos de que exista.
    final AuthController authController = Get.put(AuthController());

    // Tomamos datos falsos de nuestras APIs para llenar las secciones
    // En un caso real, usarías un FutureBuilder, Bloc, Provider o GetX.
    final List<Product> featuredProducts = ProductApi.mockProducts
        .take(4)
        .toList();

    // Generamos una lista falsa de vendedores basada en tu mock
    final List<Vendor> featuredVendors = List.generate(
      4,
      (index) => Vendor(
        id: "v$index",
        name: "Vendedor Destacado $index",
        image: "https://placehold.co/150x150/png",
        rating: 4.5,
        description:
            "Excelente servicio y calidad en cada uno de nuestros productos.",
        categories: ["Tecnología", "Accesorios"],
      ),
    );

    return Scaffold(
      // === NAVBAR PLACEHOLDER ===
      appBar: AppBar(
        title: const Text("Lince Emp"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Implementar navegación al carrito o mostrar resumen
            },
          ),
        ],
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
            Obx(() {
              final user = authController.currentUser.value;

              if (user != null) {
                // SI ESTÁ LOGUEADO -> Mostrar Perfil
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Mi Perfil'),
                  subtitle: Text(
                    user.email,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Get.back(); // Cierra el drawer (equivalente a Navigator.pop)
                    Get.to(
                      () => const ProfileScreen(),
                    ); // Navega a la pantalla de perfil
                  },
                );
              } else {
                // SI NO ESTÁ LOGUEADO -> Mostrar Iniciar sesión
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Iniciar sesión'),
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => LoginScreen(),
                    ); // Asegúrate de instanciar tu LoginScreen
                  },
                );
              }
            }),

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
            // ListTile(
            //   leading: const Icon(Icons.login),
            //   title: const Text('Iniciar sesión'),
            //   onTap: () {
            //     Navigator.pushNamed(context, '/login'); // Cierra el drawer
            //     // TODO: Navegar a pantalla de login
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.shopping_bag),
            //   title: const Text('Productos'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // TODO: Navegar a pantalla de productos
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.people),
            //   title: const Text('Colaboradores'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // TODO: Navegar a pantalla de colaboradores
            //   },
            // ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === PRODUCTOS DESTACADOS ===
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Text(
                "Productos destacados",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            // Grid de Productos (2 columnas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap:
                    true, // Importante cuando está dentro de un SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      1, // Cambiamos a 1 columna para que sea más ancha
                  childAspectRatio:
                      0.65, // Ajustamos el ratio para que no sea tan alta
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: featuredProducts[index]);
                },
              ),
            ),

            // Botón "Ver mas"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Lógica de navegación a /productos
                    // Navigator.pushNamed(context, '/productos');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade800, width: 2),
                    backgroundColor: Colors
                        .green
                        .shade50, // bg-green-800 con opacidad emulada
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Ver más",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ),
            ),

            // === COLABORADORES DESTACADOS ===
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "Nuestros colaboradores",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            // Lista de Vendedores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featuredVendors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return VendorCard(vendor: featuredVendors[index]);
                },
              ),
            ),

            // === DIVIDER INFORMACIÓN ADICIONAL ===
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 20.0,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(color: Colors.green, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Información adicional",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Colors.green, thickness: 1),
                  ),
                ],
              ),
            ),

            // === GRID DE TARJETAS DE INFORMACIÓN ===
            // Usamos Wrap para que en pantallas grandes se pongan una al lado de otra
            // y en celulares se apilen hacia abajo automáticamente.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: [
                  _buildInfoCard(
                    context,
                    title:
                        "¿Quieres ser parte de nuestra comunidad de vendedores?",
                    description:
                        "Consulta los requisitos para registrarte como vendedor en la asociación de sistemas.",
                    imageUrl: "https://placehold.co/400x400/png",
                  ),
                  _buildInfoCard(
                    context,
                    title: "¿Te suspendieron la cuenta?",
                    description:
                        "Asiste con la asociación de sistemas para resolver inconvenientes con tu cuenta.",
                    imageUrl: "https://placehold.co/400x400/png",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper para crear las tarjetas laterales de "Información adicional"
  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
  }) {
    // LayoutBuilder ayuda a adaptar el tamaño
    // Limitamos el ancho para que en pantallas web quepan 2 en la misma fila
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        color: Colors.grey.shade200, // bg-base-300
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen lateral
              SizedBox(
                width: 120,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("¡Únete a nosotros!"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
