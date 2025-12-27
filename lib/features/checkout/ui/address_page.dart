import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../../orders/providers/orders_provider.dart';
import '../../cart/providers/cart_provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _name = TextEditingController(text: 'Mrh Raju');
  final _country = TextEditingController(text: 'Bangladesh');
  final _city = TextEditingController(text: 'Sylhet');
  final _phone = TextEditingController(text: '+880 1453-987533');
  final _address = TextEditingController(text: 'Chhatak, Sunamgonj 12/8AB');

  bool _primary = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _country.dispose();
    _city.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProv = context.watch<OrdersProvider>();
    final cartProv = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _Header(title: 'Address', onBack: () => Navigator.pop(context)),
              const SizedBox(height: 24),
              const Text('Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _Field(controller: _name),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Country', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        _Field(controller: _country),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('City', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        _Field(controller: _city),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Phone Number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _Field(controller: _phone),
              const SizedBox(height: 18),
              const Text('Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _Field(controller: _address, maxLines: 2),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Save as primary address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Switch(
                    value: _primary,
                    activeThumbColor: const Color(0xFF47C16E),
                    onChanged: (v) => setState(() => _primary = v),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            onPressed: (_loading || !ordersProv.ready)
                ? null
                : () async {
                    if (await cartProv.isEmpty()) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your cart is empty')),
                      );
                      return;
                    }

                    final name = _name.text.trim();
                    final country = _country.text.trim();
                    final city = _city.text.trim();
                    final phone = _phone.text.trim();
                    final addressLine = _address.text.trim();

                    if (name.isEmpty ||
                        city.isEmpty ||
                        phone.isEmpty ||
                        addressLine.isEmpty) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields.'),
                        ),
                      );
                      return;
                    }

                    setState(() => _loading = true);
                    try {
                      await ordersProv.placeOrder(
                        address: {
                          'name': name,
                          'country': country,
                          'city': city,
                          'phone': phone,
                          'addressLine': addressLine,
                          'primary': _primary,
                        },
                      );

                      if (!mounted) return;
                      Navigator.pushNamed(context, AppRoutes.orderConfirmed);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  },
            child: Text(
              _loading ? 'Placing Order...' : 'Save Address',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _Header({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 58),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  const _Field({required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}