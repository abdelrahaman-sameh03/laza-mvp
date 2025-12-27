import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../providers/cart_provider.dart';

class CheckoutSuccessPage extends StatefulWidget {
  const CheckoutSuccessPage({super.key});

  @override
  State<CheckoutSuccessPage> createState() => _CheckoutSuccessPageState();
}

class _CheckoutSuccessPageState extends State<CheckoutSuccessPage> {
  @override
  void initState() {
    super.initState();
    // ✅ Clear cart AFTER checkout success.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CartProvider>().clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 90, color: Colors.green),
                const SizedBox(height: 14),
                const Text('Success!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text(
                  'Your order has been placed successfully.\nCart is cleared after checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.shell,
                    (r) => false,
                  ),
                  child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
