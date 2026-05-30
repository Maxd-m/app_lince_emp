class Purchase {
  final String id;
  final DateTime date;
  final double total;
  final String status;
  final String lugar;
  final List<PurchaseItem> items;

  Purchase({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.lugar,
    required this.items,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final detalles = json['detalles'] as List? ?? [];
    final transaccion = json['transaccion'] ?? {};

    return Purchase(
      id: json['id'].toString(),
      date: DateTime.tryParse(json['fecha'] ?? "") ?? DateTime.now(),
      // El total viene dentro del objeto transacción
      total: double.tryParse(transaccion['total']?.toString() ?? '0.0') ?? 0.0,
      status: json['status'] ?? 'desconocido',
      lugar: json['lugar'] ?? 'No especificado',
      items: detalles.map((item) => PurchaseItem.fromJson(item)).toList(),
    );
  }
}

class PurchaseItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final String sellerName;
  final String sellerEmail;
  final String sellerPhone;

  PurchaseItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerPhone,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    final producto = json['producto'] ?? {};
    // Intentamos obtener la primera imagen del producto si existe
    final imagenes = producto['imagenes'] as List? ?? [];
    final vendedor = producto['vendedor'] ?? {};
    return PurchaseItem(
      productId: json['id_producto'].toString(),
      productName: producto['nombre'] ?? 'Producto',
      price:
          double.tryParse(json['precio_unitario']?.toString() ?? '0.0') ?? 0.0,
      quantity: json['cantidad'] as int? ?? 1,
      imageUrl: imagenes.isNotEmpty
          ? imagenes[0]['url_imagen']
          : "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
      sellerName: vendedor['nombre'] ?? 'No disponible',
      sellerEmail: vendedor['correo'] ?? 'No disponible',
      sellerPhone: vendedor['telefono'] ?? 'No disponible',
    );
  }
}
