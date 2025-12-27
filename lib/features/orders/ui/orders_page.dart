import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../data/order_model.dart';
import '../providers/orders_provider.dart';
import 'order_details_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProv = context.watch<OrdersProvider>();

    if (!ordersProv.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,

        // ✅ Back button (works even if page can't pop)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.shell,
                (r) => false,
              );
            }
          },
        ),

        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: ordersProv.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? const <OrderModel>[];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final o = orders[index];
              return _OrderCard(order: o);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final canCancel = order.status.trim().toLowerCase() == 'placed';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id.substring(0, 6).toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.items.length} items • \$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
                  ),
                  if (order.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.createdAt!),
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            _StatusChip(status: order.status),
            const SizedBox(width: 10),
            Icon(
              canCancel ? Icons.chevron_right : Icons.receipt_long,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
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
