import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reviews_controller.dart';
import '../widgets/app_drawer.dart';
import '../widgets/review_card.dart';
import '../models/product_model.dart'; // Asegúrate de tener el Review model

class ReviewsScreen extends StatelessWidget {
  ReviewsScreen({Key? key}) : super(key: key);

  final ReviewsController controller = Get.put(ReviewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reseñas"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'reviews'),
      body: Column(
        children: [
          // SWITCH de selección
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vendedores",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: controller.isProductView.value,
                    onChanged: (val) => controller.isProductView.value = val,
                    activeColor: Colors.blueGrey,
                  ),
                  const Text(
                    "Productos",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.isProductView.value
                  ? controller.productReviews
                  : controller.vendorReviews;

              if (list.isEmpty) {
                return const Center(
                  child: Text("No has realizado reseñas aún."),
                );
              }

              return ListView.builder(
                itemCount: list.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = list[index];
                  // Adaptamos el JSON al modelo Review que espera el ReviewCard
                  final review = Review(
                    id: item['id'].toString(),
                    userName: "Tú",
                    userAvatar:
                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                    calificacion: (item['calificacion'] ?? 5).toDouble(),
                    comentario: item['comentario'] ?? "",
                    date: item['created_at'] ?? "",
                  );

                  final subText = controller.isProductView.value
                      ? "Producto: ${item['producto']?['nombre'] ?? 'N/A'}"
                      : "Vendedor: ${item['vendedor']?['nombre'] ?? 'N/A'}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                        child: Text(
                          subText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      ReviewCard(review: review),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReviewModal(context),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  void _showCreateReviewModal(BuildContext context) {
    final items = controller.isProductView.value
        ? controller.getPendingProducts()
        : controller.getPendingVendors();

    if (items.isEmpty) {
      Get.snackbar(
        "Aviso",
        "No tienes compras pendientes por reseñar en esta categoría.",
      );
      return;
    }

    String? selectedId;
    double rating = 5.0;
    final commentController = TextEditingController();
    bool isAnonymous = false;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nueva Reseña de ${controller.isProductView.value ? 'Producto' : 'Vendedor'}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Selecciona el destino",
                ),
                items: items
                    .map(
                      (i) => DropdownMenuItem(
                        value: i['id'].toString(),
                        child: Text(i['nombre']),
                      ),
                    )
                    .toList(),
                onChanged: (val) => selectedId = val,
              ),
              const SizedBox(height: 20),
              const Text("Calificación:"),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                        onPressed: () => setState(() => rating = index + 1.0),
                      ),
                    ),
                  );
                },
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: "Comentario",
                  hintText: "¿Qué te pareció?",
                ),
                maxLines: 3,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    title: const Text("Publicar como anónimo"),
                    value: isAnonymous,
                    onChanged: (val) =>
                        setState(() => isAnonymous = val ?? false),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    if (selectedId == null) {
                      Get.snackbar("Error", "Selecciona a quién reseñar");
                      return;
                    }
                    controller.submitReview(
                      id: selectedId!,
                      rating: rating,
                      comment: commentController.text,
                      anonymous: isAnonymous,
                    );
                    Get.back();
                  },
                  child: const Text(
                    "Enviar Reseña",
                    style: TextStyle(color: Colors.white),
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
