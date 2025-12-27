import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_model.dart';

class OrdersRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) =>
      _db.collection('orders').doc(userId).collection('items');

  Stream<List<OrderModel>> watchOrders(String userId) {
    return _itemsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  Future<String> createOrder({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final doc = await _itemsRef(userId).add({
      ...data,
      // always use server time for ordering
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> cancelOrder({
    required String userId,
    required String orderId,
  }) async {
    await _itemsRef(userId).doc(orderId).set({
      'status': 'canceled',
      'canceledAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<OrderModel?> getOrder({
    required String userId,
    required String orderId,
  }) async {
    final doc = await _itemsRef(userId).doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromDoc(doc);
  }
}
