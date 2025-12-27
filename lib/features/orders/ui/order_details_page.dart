import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../data/order_model.dart';
import '../providers/orders_provider.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final ordersProv = context.read<OrdersProvider>();
    final canCancel = order.status.trim().toLowerCase() == 'placed';

    final addr = order.address;
    final name = (addr['name'] ?? '').toString();
    final phone = (addr['phone'] ?? '').toString();
    final city = (addr['city'] ?? '').toString();
    final line = (addr['addressLine'] ?? addr['address'] ?? '').toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text('Order Details', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order #${order.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                    _StatusChip(status: order.status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${order.items.length} items • \$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700),
                ),
                if (order.createdAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Placed on: ${_formatDate(order.createdAt!)}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                if (name.isNotEmpty) Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                if (phone.isNotEmpty) Text(phone, style: const TextStyle(color: AppColors.muted)),
                if (city.isNotEmpty) Text(city, style: const TextStyle(color: AppColors.muted)),
                if (line.isNotEmpty) Text(line, style: const TextStyle(color: AppColors.muted)),
                if (name.isEmpty && phone.isEmpty && city.isEmpty && line.isEmpty)
                  const Text('—', style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Items', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                ...order.items.map((it) {
                  final title = (it['title'] ?? '').toString();
                  final qty = (it['qty'] ?? it['quantity'] ?? 1) as num;
                  final price = (it['price'] ?? 0) as num;
                  final image = (it['image'] ?? it['imageUrl'] ?? '').toString();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Thumb(url: image),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text('Qty: ${qty.toInt()} • \$${price.toDouble().toStringAsFixed(2)}', style: const TextStyle(color: AppColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (canCancel)
            SizedBox(
              height: 54,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                  await ordersProv.cancel(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order canceled')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        color: const Color(0xFFF3F4F6),
        child: url.isEmpty
            ? const Icon(Icons.image_not_supported_outlined)
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported_outlined),
              ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    final text = normalized.isEmpty ? 'unknown' : normalized;

    Color bg;
    Color fg;
    if (text == 'placed') {
      bg = const Color(0xFFE8F5E9);
      fg = const Color(0xFF2E7D32);
    } else if (text == 'canceled' || text == 'cancelled') {
      bg = const Color(0xFFFFEBEE);
      fg = const Color(0xFFC62828);
    } else {
      bg = const Color(0xFFEDE7F6);
      fg = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}
