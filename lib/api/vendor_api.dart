// lib/api/vendor_api.dart

import '../models/vendor_model.dart';
import '../models/product_model.dart'; // Necesario para la lista de productos

class VendorApi {
  static Future<VendorDetail?> fetchVendorById(String id) async {
    return Future.delayed(const Duration(milliseconds: 800), () {
      // Mock de datos simulando la BD
      return VendorDetail(
        id: id,
        name: "Tech & Travel",
        image: "https://placehold.co/400x400/png",
        rating: 4.8,
        description:
            "Especialistas en accesorios para el día a día y viajes. Ofrecemos mochilas, organizadores y tecnología portátil de la más alta calidad. Nuestro compromiso es tu comodidad.",
        categories: ["Viajes", "Accesorios", "Mochilas", "Impermeable"],
        products: [
          Product(
            id: "1",
            name: "Mochila Urban Explorer",
            description:
                "Mochila resistente al agua ideal para estudiantes y viajeros...",
            price: 850.5,
            stock: 24,
            images: ["https://placehold.co/400x300/png"],
            // Pasamos un Vendor base para el producto
            vendor: Vendor(
              id: id,
              name: "Tech & Travel",
              image: "https://placehold.co/400x400/png",
              rating: 4.8,
              description: "",
              categories: [],
            ),
            reviews: [],
          ),
          // Puedes agregar el segundo producto mock aquí...
        ],
        reviews: [
          Review(
            id: "rv1",
            userName: "Ana Gómez",
            userAvatar: "https://placehold.co/100x100/png",
            rating: 5,
            comment:
                "El vendedor envió todo muy rápido y súper bien empaquetado. Totalmente recomendado.",
            date: "2024-05-01",
          ),
          Review(
            id: "rv2",
            userName: "Carlos Ruiz",
            userAvatar: "https://placehold.co/100x100/png",
            rating: 4,
            comment:
                "El vendedor envió todo muy rápido y súper bien empaquetado. Totalmente recomendado.",
            date: "2024-05-01",
          ),
        ],
      );
    });
  }
}
