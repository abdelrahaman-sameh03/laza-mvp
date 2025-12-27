import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String status;
  final double total;
  final DateTime? createdAt;
  final Map<String, dynamic> address;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.address,
    required this.items,
  });

  factory OrderModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};

    DateTime? createdAt;
    final ts = d['createdAt'];
    if (ts is Timestamp) createdAt = ts.toDate();
    if (ts is DateTime) createdAt = ts;

    final rawItems = (d['items'] as List?) ?? const [];
    final items = rawItems
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();

    final address = Map<String, dynamic>.from((d['address'] as Map?) ?? {});

    return OrderModel(
      id: doc.id,
      status: (d['status'] ?? 'placed').toString(),
      total: (d['total'] is num) ? (d['total'] as num).toDouble() : 0.0,
      createdAt: createdAt,
      address: address,
      items: items,
    );
  }
}
