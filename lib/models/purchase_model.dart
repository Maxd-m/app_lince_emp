class Purchase {
  final String id;
  final DateTime date;
  final double total;
  final String status;
  final List<PurchaseItem> items;

  Purchase({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });
}

class PurchaseItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  PurchaseItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
