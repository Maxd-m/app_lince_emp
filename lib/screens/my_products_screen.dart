import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_products_controller.dart';
import '../widgets/app_drawer.dart';

class MyProductsScreen extends StatelessWidget {
  MyProductsScreen({Key? key}) : super(key: key);

  final MyProductsController controller = Get.put(MyProductsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Productos"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'my_products'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myProducts.isEmpty) {
          return const Center(
            child: Text(
              "No tienes productos registrados.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myProducts.length,
          itemBuilder: (context, index) {
            final product = controller.myProducts[index];
            final imageUrl = product.images.isNotEmpty
                ? product.images.first
                : "https://placehold.co/100x100/png";

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 40),
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text("Stock: ${product.stock} unidades"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => controller.editProduct(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteProduct(product),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>  controller.createdProduct(context),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
