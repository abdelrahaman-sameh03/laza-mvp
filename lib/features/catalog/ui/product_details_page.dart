import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_helpers.dart';

import '../providers/products_provider.dart';
import '../data/product_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../cart/data/cart_item.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../favorites/data/favorite_item.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _imgIndex = 0;
  String _size = 'M';

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>();
    final cart = context.watch<CartProvider>();
    final fav = context.watch<FavoritesProvider>();

    return FutureBuilder<Product>(
      future: products.getById(widget.productId),
      builder: (_, snap) {
        if (!snap.hasData) {
          if (snap.hasError) return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final p = snap.data!;
        final images = p.images.isNotEmpty ? p.images : [p.mainImage];

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 380,
                      child: PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => _imgIndex = i),
                        itemBuilder: (_, i) => images[i].isEmpty
                            ? const ColoredBox(color: Color(0xFFF5F6FA))
                            : CachedNetworkImage(imageUrl: images[i], fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.9)),
                      ),
                    ),
                  ],
                ),

                if (images.length > 1)
                  SizedBox(
                    height: 74,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        final selected = i == _imgIndex;
                        return Container(
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selected ? AppColors.primary : Colors.transparent, width: 2),
                            color: const Color(0xFFF5F6FA),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(imageUrl: images[i], fit: BoxFit.cover),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: images.length,
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text('\$${p.price}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),

                      const Text('Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: ['S', 'M', 'L', 'XL', '2XL'].map((s) {
                          final selected = s == _size;
                          return ChoiceChip(
                            label: Text(s),
                            selected: selected,
                            onSelected: (_) => setState(() => _size = s),
                            selectedColor: AppColors.primary.withOpacity(0.2),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),
                      const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        p.description.isEmpty ? 'No description available.' : p.description,
                        style: const TextStyle(color: AppColors.muted, height: 1.4),
                      ),

                      const SizedBox(height: 18),
                      Row(
                        children: [
                          StreamBuilder<bool>(
                            stream: fav.watchIsFavorite(p.id),
                            builder: (_, snapFav) {
                              final isFav = snapFav.data ?? false;
                              return IconButton(
                                tooltip: 'Favorite',
                                onPressed: () async {
                                  if (!fav.ready) {
                                    UiHelpers.showSnack(context, 'Please login first');
                                    return;
                                  }
                                  await fav.toggle(
                                    FavoriteItem(productId: p.id, title: p.title, price: p.price.toDouble(), image: p.mainImage),
                                  );
                                },
                                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.muted),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Semantics(
                              label: 'add_to_cart_btn',
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () async {
                                  if (!cart.ready) {
                                    UiHelpers.showSnack(context, 'Please login first');
                                    return;
                                  }
                                  await cart.add(
                                    CartItem(productId: p.id, title: p.title, price: p.price, image: p.mainImage, quantity: 1),
                                  );
                                  if (mounted) UiHelpers.showSnack(context, 'Added to cart (size: $_size)');
                                },
                                child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
