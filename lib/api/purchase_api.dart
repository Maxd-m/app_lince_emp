import '../models/purchase_model.dart';

class PurchaseApi {
  static final List<Purchase> mockPurchases = [
    Purchase(
      id: "ORD-7721",
      date: DateTime.now().subtract(const Duration(days: 2)),
      total: 1701.0,
      status: "Entregado",
      items: [
        PurchaseItem(
          productId: "1",
          productName: "Mochila Urban Explorer",
          price: 850.5,
          quantity: 2,
          imageUrl:
              "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
        ),
      ],
    ),
    Purchase(
      id: "ORD-8842",
      date: DateTime.now().subtract(const Duration(days: 10)),
      total: 450.0,
      status: "En camino",
      items: [
        PurchaseItem(
          productId: "2",
          productName: "Termo Acero Inoxidable",
          price: 450.0,
          quantity: 1,
          imageUrl:
              "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
        ),
      ],
    ),
  ];

  static Future<List<Purchase>> fetchPurchases() async {
    return Future.delayed(
      const Duration(milliseconds: 1000),
      () => mockPurchases,
    );
  }
}
