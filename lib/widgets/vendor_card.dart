// lib/components/vendor_card.dart

import 'package:app_lince_emp/screens/vendor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/vendor_model.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final VoidCallback? onTap;

  const VendorCard({Key? key, required this.vendor, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Centralizamos la navegación del vendedor
    void _onNavigate() {
      onTap != null
          ? onTap!()
          : Get.to(() => VendorDetailsScreen(), arguments: vendor.id);
    }

    // Valores por defecto como en tu React
    final int ratingStars = vendor.rating > 0 ? vendor.rating.round() : 5;
    final List<String> categories = vendor.categories;
    final String description = vendor.description.isNotEmpty
        ? vendor.description
        : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras finibus ultrices congue. Class aptent taciti sociosqu.";

    return Card(
      elevation:
          0, // shadow-sm (lo simulamos con un borde en lugar de gran sombra)
      color: Colors.grey[100], // bg-base-200/70 aproximación
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // rounded-xl
        side: BorderSide(color: Colors.grey.shade300), // border-base-300
      ),
      child: InkWell(
        onTap: _onNavigate,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // p-5
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Avatar + Detalles
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar circular (mask mask-circle)
                  GestureDetector(
                    onTap: _onNavigate,
                    child: CircleAvatar(
                      radius: 40, // w-24 / w-28 aproximación
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        vendor.url.isNotEmpty
                            ? vendor.url
                            : "https://placehold.co/400x400/png",
                      ),
                    ),
                  ),

                  const SizedBox(width: 20), // gap-5
                  // Columna derecha: Rating, Descripción, Categorías
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estrellas alineadas a la derecha
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Text(
                                index < ratingStars ? "★" : "☆",
                                style: const TextStyle(fontSize: 18),
                              );
                            }),
                          ),
                        ),

                        // Descripción truncada (line-clamp-3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Categorías (badge badge-info)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((cat) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50, // badge-soft
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                ), // info border
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Fila inferior: Título + Botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título del vendedor
                  Expanded(
                    child: GestureDetector(
                      onTap: _onNavigate,
                      child: Text(
                        vendor.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Botón "Ver perfil" (rounded-none btn-primary)
                  ElevatedButton(
                    onPressed: _onNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .zero, // rounded-none tal cual pediste en Tailwind
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Ver perfil"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
