// lib/api/vendor_api.dart

import '../models/vendor_model.dart';
import '../models/product_model.dart';

class VendorApi {
  static Future<VendorDetail?> fetchVendorById(String id) async {
    return Future.delayed(const Duration(milliseconds: 800), () {
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
        ],
        reviews: [
          Review(
            id: "rv1",
            userName: "Ana Gómez",
            userAvatar: "https://placehold.co/100x100/png",
            rating: 5.0, // <-- CAMBIO: De 5 a 5.0
            comment:
                "El vendedor envió todo muy rápido y súper bien empaquetado. Totalmente recomendado.",
            date: "2024-05-01",
          ),
          Review(
            id: "rv2",
            userName: "Carlos Ruiz",
            userAvatar: "https://placehold.co/100x100/png",
            rating: 4.0, // <-- CAMBIO: De 4 a 4.0
            comment:
                "El vendedor envió todo muy rápido y súper bien empaquetado. Totalmente recomendado.",
            date: "2024-05-01",
          ),
        ],
      );
    });
  }
}
