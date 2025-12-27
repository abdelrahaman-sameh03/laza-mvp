import 'package:flutter/foundation.dart';

import '../data/cart_repo.dart';
import '../data/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo _repo = CartRepo();
  String? _userId;

  void setUser(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  bool get ready => _userId != null;

  Stream<List<CartItem>> watchCart() {
    if (_userId == null) return Stream<List<CartItem>>.empty();
    return _repo.watchCart(_userId!);
  }

  Future<List<CartItem>> itemsOnce() async {
    if (_userId == null) return <CartItem>[];
    return watchCart().first;
  }

  Future<bool> isEmpty() async {
    final items = await itemsOnce();
    return items.isEmpty;
  }

  Future<int> totalItems() async {
    final items = await itemsOnce();
    return items.length;
  }

  Future<void> add(CartItem item) async {
    if (_userId == null) return;
    await _repo.addOrIncrement(_userId!, item);
  }

  Future<void> setQty(int productId, int qty) async {
    if (_userId == null) return;
    await _repo.setQuantity(_userId!, productId, qty);
  }

  Future<void> remove(int productId) async {
    if (_userId == null) return;
    await _repo.remove(_userId!, productId);
  }

  Future<void> clear() async {
    if (_userId == null) return;
    await _repo.clear(_userId!);
  }
}