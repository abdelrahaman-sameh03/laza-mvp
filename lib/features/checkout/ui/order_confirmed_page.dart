import 'package:flutter/material.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: () {
                // back to shopping (Home tab)
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (r) => false);
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: _CircleIcon(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration-ish (simple, no assets required)
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(140),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.phone_iphone, size: 120, color: AppColors.muted.withOpacity(0.35)),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 40),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Order Confirmed!',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your order has been confirmed, we will send\n'
                      'you confirmation email shortly.',
                      style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.card,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.orders, (r) => false);
                        },
                        child: const Text(
                          'Go to Orders',
                          style: TextStyle(color: AppColors.muted, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F6FA),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: AppColors.text),
        ),
      ),
    );
  }
}
