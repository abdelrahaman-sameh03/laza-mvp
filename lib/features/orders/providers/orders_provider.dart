import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../cart/data/cart_item.dart';
import '../../cart/data/cart_repo.dart';
import '../data/order_model.dart';
import '../data/orders_repo.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersRepo _ordersRepo = OrdersRepo();
  final CartRepo _cartRepo = CartRepo();

  String? _userId;

  void setUser(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  bool get ready => _userId != null;

  Stream<List<OrderModel>> watchAll() {
    final uid = _userId;
    if (uid == null) return Stream.empty();
    return _ordersRepo.watchOrders(uid);
  }

  /// Creates an order from the current cart items, then clears the cart.
  /// Returns the new orderId.
  Future<String?> placeOrder({
    required Map<String, dynamic> address,
  }) async {
    final uid = _userId;
    if (uid == null) return null;

    // Get current cart items (once)
    final List<CartItem> cartItems = await _cartRepo.watchCart(uid).first;
    if (cartItems.isEmpty) {
      throw Exception('Your cart is empty');
    }

    final items = cartItems
        .map((c) => <String, dynamic>{
              'productId': c.productId,
              'title': c.title,
              'price': c.price,
              'qty': c.quantity,
              'image': c.image,
            })
        .toList();

    final total = cartItems.fold<double>(
      0.0,
      (sum, c) => sum + (c.price.toDouble() * c.quantity),
    );

    final orderId = await _ordersRepo.createOrder(
      userId: uid,
      data: {
        'status': 'placed',
        'items': items,
        'address': address,
        'total': total,
      },
    );

    await _cartRepo.clear(uid);
    return orderId;
  }

  Future<void> cancel(String orderId) async {
    final uid = _userId;
    if (uid == null) return;
    await _ordersRepo.cancelOrder(userId: uid, orderId: orderId);
  }
}
