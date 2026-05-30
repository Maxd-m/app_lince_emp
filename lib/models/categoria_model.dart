class Categoria {
  final String id;
  final String name;
  final String? icon;
  final String? color;


  Categoria({
    required this.id,
    required this.name,
    this.icon,
    this.color
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'].toString(), // Convertimos int a String para mantener tu modelo
      name: json['nombre'] ?? '',
      icon: json['icono'],
      color: json['color'],
    );
  }
}

