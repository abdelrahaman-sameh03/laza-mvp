import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../app/router/app_routes.dart';
import '../../auth/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Signed in as', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 8),
              Text(
                auth.email ?? 'Unknown',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.orders),
                  child: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Semantics(
                  label: 'logout_btn',
                  button: true,
                  child: OutlinedButton(
                    onPressed: () async {
                    try {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authGate, (r) => false);
                      }
                    } catch (e) {
                      if (context.mounted) UiHelpers.showSnack(context, 'Logout failed: $e');
                    }
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
