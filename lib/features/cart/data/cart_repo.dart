import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class CartRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) =>
      _db.collection('carts').doc(userId).collection('items');

  Stream<List<CartItem>> watchCart(String userId) {
    return _itemsRef(userId).snapshots().map(
          (snap) => snap.docs.map((d) => CartItem.fromDoc(d)).toList(),
        );
  }

  Future<void> addOrIncrement(String userId, CartItem item) async {
    final ref = _itemsRef(userId).doc(item.productId.toString());
    await _db.runTransaction((tx) async {
      final doc = await tx.get(ref);
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final currentQty = (data['quantity'] ?? 1) as int;
        tx.set(ref, item.copyWith(quantity: currentQty + 1).toMap(), SetOptions(merge: true));
      } else {
        tx.set(ref, item.toMap(), SetOptions(merge: true));
      }
    });
  }

  Future<void> setQuantity(String userId, int productId, int qty) async {
    final ref = _itemsRef(userId).doc(productId.toString());
    if (qty <= 0) {
      await ref.delete();
      return;
    }
    await ref.set({'quantity': qty, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> remove(String userId, int productId) async {
    await _itemsRef(userId).doc(productId.toString()).delete();
  }

  Future<void> clear(String userId) async {
    final snap = await _itemsRef(userId).get();
    final batch = _db.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}
