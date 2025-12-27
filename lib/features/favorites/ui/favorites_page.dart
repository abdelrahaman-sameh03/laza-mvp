import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../data/favorite_item.dart';
import '../../../app/router/app_routes.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _editMode = false;
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();

    if (!fav.ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          /// Select All (يظهر فقط في Edit)
          if (_editMode)
            TextButton(
              onPressed: () async {
                final items = await fav.watchAll().first;
                setState(() {
                  _selected.clear();
                  for (final it in items) {
                    _selected.add(it.productId);
                  }
                });
              },
              child: const Text('Select all'),
            ),

          /// Edit / Done
          TextButton(
            onPressed: () {
              setState(() {
                _editMode = !_editMode;
                _selected.clear();
              });
            },
            child: Text(_editMode ? 'Done' : 'Edit'),
          ),
        ],
      ),

      /// زر الحذف الجماعي
      bottomNavigationBar: _editMode && _selected.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () async {
                  for (final id in _selected) {
                    await fav.remove(id);
                  }
                  setState(() {
                    _selected.clear();
                    _editMode = false;
                  });
                },
                child: Text(
                  'Delete (${_selected.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          : null,

      body: StreamBuilder<List<FavoriteItem>>(
        stream: fav.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.62,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final it = items[i];
              final selected = _selected.contains(it.productId);

              return GestureDetector(
                /// 🔥 Long press → يدخل Edit ويحدد
                onLongPress: () {
                  setState(() {
                    _editMode = true;
                    _selected.add(it.productId);
                  });
                },

                /// Tap
                onTap: () {
                  if (_editMode) {
                    setState(() {
                      selected
                          ? _selected.remove(it.productId)
                          : _selected.add(it.productId);
                    });
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetails,
                      arguments: it.productId,
                    );
                  }
                },

                child: Stack(
                  children: [
                    _WishlistCard(
                      item: it,
                      selected: selected,
                    ),

                    /// Check icon في Edit
                    if (_editMode)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected ? Colors.red : Colors.grey,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final FavoriteItem item;
  final bool selected;

  const _WishlistCard({
    required this.item,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(22),
              border: selected
                  ? Border.all(color: Colors.red, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: item.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '\$${item.price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
