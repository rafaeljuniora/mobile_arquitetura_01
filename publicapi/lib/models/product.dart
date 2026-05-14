class Product {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final String? thumbnail;
  final bool favorite;

  const Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.thumbnail,
    this.favorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _asIntOrNull(json['id']),
      title: json['title']?.toString() ?? '',
      price: _asDouble(json['price']),
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
        image: json['images'] is List && (json['images'] as List).isNotEmpty
          ? (json['images'] as List).first.toString()
          : (json['image']?.toString() ?? json['thumbnail']?.toString() ?? ''),
        thumbnail: json['thumbnail']?.toString(),
        favorite: json['favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      if (thumbnail != null) 'thumbnail': thumbnail,
      'favorite': favorite,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    String? thumbnail,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      thumbnail: thumbnail ?? this.thumbnail,
      favorite: favorite ?? this.favorite,
    );
  }

  static int? _asIntOrNull(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
