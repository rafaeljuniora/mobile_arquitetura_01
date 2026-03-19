class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double ratingRate;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    final ratingMap = rating is Map<String, dynamic>
        ? rating
        : <String, dynamic>{};

    return ProductModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? 'Produto sem nome',
      price: _asDouble(json['price']),
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? 'Sem descricao',
      category: json['category']?.toString() ?? 'Sem categoria',
      ratingRate: _asDouble(ratingMap['rate']),
      ratingCount: _asInt(ratingMap['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
      'rating': {'rate': ratingRate, 'count': ratingCount},
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
