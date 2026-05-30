// lib/screens/home_screen.dart

import 'package:app_lince_emp/controllers/vendor_controller.dart';
import 'package:app_lince_emp/screens/products_screen.dart';
import 'package:app_lince_emp/screens/cart_screen.dart';
import 'package:app_lince_emp/screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart'; // <-- AÑADIDO: Importamos el controlador de productos
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/vendor_card.dart';
import '../models/vendor_model.dart';
import '../widgets/app_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectamos los controladores
    final AuthController authController = Get.put(AuthController());
    final ProductController productController = Get.put(ProductController());
    final CartController cartController = Get.put(
      CartController(),
      permanent: true,
    );

    // --> AÑADE EL CONTROLADOR DE VENDEDORES:
    final VendorController vendorController = Get.put(VendorController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lince Emp"),
        backgroundColor: Colors.blueGrey,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Get.to(() => CartScreen()),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Obx(
                  () => cartController.itemCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartController.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'home'),
      body: RefreshIndicator(
        onRefresh: () => productController.loadProducts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Text(
                  "Productos destacados",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              // === AQUI USAMOS Obx PARA ESCUCHAR EL API ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Tomamos los primeros 4 productos del API real
                  final featuredProducts = productController.allProducts
                      .take(4)
                      .toList();

                  if (featuredProducts.isEmpty) {
                    return const Center(
                      child: Text("No se encontraron productos."),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: featuredProducts[index]);
                    },
                  );
                }),
              ),

              // Botón "Ver mas"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => ProductsScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green.shade800, width: 2),
                      backgroundColor: Colors.green.shade50,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  if (vendorController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Tomamos un máximo de 4 vendedores para destacar
                  final featured = vendorController.allVendors.take(4).toList();

                  if (featured.isEmpty) {
                    return const Center(
                      child: Text("Aún no hay colaboradores destacados."),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featured.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return VendorCard(vendor: featured[index]);
                    },
                  );
                }),
              ),

              // === DIVIDER E INFORMACIÓN ADICIONAL ===
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
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        color: Colors.grey.shade200,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 120,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
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
