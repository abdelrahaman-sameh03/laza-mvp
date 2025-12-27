import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  num _subtotal(List items) {
    num s = 0;
    for (final it in items) {
      s += (it.price * it.quantity);
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Semantics(
      label: 'cart_screen',
      child: Scaffold(
        appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: cart.watchCart(),
          builder: (_, snap) {
            if (!cart.ready) {
              return const Center(child: Text('Please login to use cart.'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snap.data!;
            if (items.isEmpty) {
              return const Center(child: Text('Your cart is empty.'));
            }

            final subtotal = _subtotal(items);

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      return Semantics(
                        label: 'cart_item_${it.productId}',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: it.image.isEmpty
                                    ? const SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: ColoredBox(color: Color(0xFFF5F6FA)),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: it.image,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: ColoredBox(color: Color(0xFFF5F6FA)),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      it.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${it.price}',
                                      style: const TextStyle(fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => cart.setQty(it.productId, it.quantity - 1),
                                  ),
                                  Text(
                                    '${it.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => cart.setQty(it.productId, it.quantity + 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: AppColors.muted)),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () async {
                      // ✅ Don't clear the cart here.
                      // Clear it only after the order is successfully placed.
                      if (context.mounted) Navigator.pushNamed(context, AppRoutes.payment);
                    },
                    child: const Text(
                      'Confirm Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      ),
    );
  }
}
