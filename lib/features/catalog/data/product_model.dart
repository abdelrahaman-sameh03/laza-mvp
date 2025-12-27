class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imgs = (json['images'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    return Product(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] ?? 0) as num,
      images: imgs,
    );
  }

  String get mainImage => images.isNotEmpty ? images.first : '';
}
