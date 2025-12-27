import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_item.dart';

class FavoritesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) =>
      _db.collection('favorites').doc(userId).collection('items');

  Stream<List<FavoriteItem>> watchFavorites(String userId) {
    return _itemsRef(userId).snapshots().map(
          (snap) => snap.docs.map((d) => FavoriteItem.fromDoc(d)).toList(),
        );
  }

  Stream<bool> watchIsFavorite(String userId, int productId) {
    return _itemsRef(userId).doc(productId.toString()).snapshots().map((doc) => doc.exists);
  }

  Future<void> toggle(String userId, FavoriteItem item) async {
    final ref = _itemsRef(userId).doc(item.productId.toString());
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set(item.toMap(), SetOptions(merge: true));
    }
  }

  Future<void> remove(String userId, int productId) async {
    await _itemsRef(userId).doc(productId.toString()).delete();
  }
}
