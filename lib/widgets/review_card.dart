// lib/components/review_card.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart'; // Asegúrate de que aquí viva tu clase Review

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
      "COntenido review: ${review.comentario}, calificacion: ${review.calificacion}",
    ); // Debugging
    return Card(
      elevation: 1,
      color: Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera: Avatar, Nombre, Fecha y Estrellas
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.userAvatar),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        review.date,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Estrellas
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < review.calificacion
                          ? Colors.orange
                          : Colors.grey.shade300,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Comentario
            Text(
              review.comentario,
              style: TextStyle(color: Colors.grey.shade800, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
