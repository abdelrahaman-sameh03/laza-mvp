import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../app/router/app_routes.dart';
import '../providers/products_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../favorites/data/favorite_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductsProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>();
    final fav = context.watch<FavoritesProvider>();

    return Semantics(
      label: 'home_screen',
      child: Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.text)),
              Text('Welcome to Laza.', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        actions: const [SizedBox(width: 6)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              onChanged: products.setQuery,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (products.loading) return const Center(child: CircularProgressIndicator());
                  if (products.error != null) return Center(child: Text('Error: ${products.error}'));
                  if (products.products.isEmpty) return const Center(child: Text('No products'));

                  return Semantics(
                    label: 'home_product_list',
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.products.length,
                      itemBuilder: (_, i) {
                        final p = products.products[i];
                        return Semantics(
                          label: 'product_card_${p.id}',
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: p.id),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                            child: p.mainImage.isEmpty
                                                ? const ColoredBox(color: Color(0xFFF5F6FA))
                                                : CachedNetworkImage(
                                                    imageUrl: p.mainImage,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFF5F6FA)),
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: StreamBuilder<bool>(
                                            stream: fav.watchIsFavorite(p.id),
                                            builder: (_, snap) {
                                              final isFav = snap.data ?? false;
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (!fav.ready) {
                                                    UiHelpers.showSnack(context, 'Please login first');
                                                    return;
                                                  }
                                                  await fav.toggle(
                                                    FavoriteItem(productId: p.id, title: p.title, price: p.price.toDouble(), image: p.mainImage),
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white.withOpacity(0.9),
                                                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.muted),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 6),
                                        Text('\$${p.price}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
