class Product {
  final int? id;
  final String name;
  final int price;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] is String 
          ? double.parse(json['price']).toInt() 
          : (json['price'] as num? ?? 0).toInt(),
      description: json['description'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price, 
      'description': description,
    };
  }
}
