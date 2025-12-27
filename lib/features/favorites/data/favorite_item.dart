import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final int productId;
  final String title;
  final double price;
  final String image;

  FavoriteItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
  });

  factory FavoriteItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return FavoriteItem(
      productId: (d['productId'] as num).toInt(),
      title: (d['title'] ?? '').toString(),
      price: (d['price'] as num?)?.toDouble() ?? 0.0,
      image: (d['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
