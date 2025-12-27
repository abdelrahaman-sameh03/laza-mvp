import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final int productId;
  final String title;
  final num price;
  final String image;
  final int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return CartItem(
      productId: (d['productId'] as num).toInt(),
      title: (d['title'] ?? '').toString(),
      price: (d['price'] ?? 0) as num,
      image: (d['image'] ?? '').toString(),
      quantity: (d['quantity'] ?? 1) as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        title: title,
        price: price,
        image: image,
        quantity: quantity ?? this.quantity,
      );
}
