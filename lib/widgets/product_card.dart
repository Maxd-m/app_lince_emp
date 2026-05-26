// lib/components/product_card.dart

import 'package:app_lince_emp/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap; // Equivalente a la acción del <Link>

  const ProductCard({Key? key, required this.product, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tomamos la primera imagen del arreglo de imágenes, o un placeholder si está vacío
    final imageUrl = product.images.isNotEmpty
        ? product.images.first
        : "https://placehold.co/400x300/png";

    // Cálculo de estrellas promedio: Movemos el cálculo aquí, fuera del árbol de widgets.
    final averageRating = product.reviews.isNotEmpty
        ? (product.reviews.map((r) => r.calificacion).reduce((a, b) => a + b) /
              product.reviews.length)
        : 0.0;

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip
          .antiAlias, // Necesario para que la imagen respete los bordes redondeados
      child: InkWell(
        onTap:
            onTap ??
            () {
              Get.to(() => ProductDetailsScreen(), arguments: product.id);

              // TODO: Agrega tu lógica de navegación aquí
              // Ejemplo: Navigator.pushNamed(context, '/product/${product.id}');
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Imagen del producto
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // 2. Cuerpo de la tarjeta
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Fila de título y rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Display de estrellas basado en el rating promedio
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              color: index < averageRating.round()
                                  ? Colors
                                        .orange // Usamos naranja para consistencia con ProductDetailsScreen
                                  : Colors.grey[300],
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Texto de relleno
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Fila de Precio y Botón "Ver más"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed:
                              onTap ??
                              () {
                                Get.to(
                                  () => ProductDetailsScreen(),
                                  arguments: product.id,
                                );
                              }, // Misma lógica de navegación del InkWell
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text("Ver más"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
