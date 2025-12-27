import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.25,
                child: Image.asset('assets/figma/Screen 1.png', fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Look Good, Feel Good',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your individual & unique style and look amazing everyday.',
                      style: TextStyle(color: AppColors.muted, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _go(context, 'men'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Men', style: TextStyle(color: AppColors.muted)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _go(context, 'women'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Women', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.authGate),
                      child: const Text('Skip', style: TextStyle(color: AppColors.muted)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _go(BuildContext context, String gender) {
  Navigator.pushReplacementNamed(
    context,
    AppRoutes.getStarted,
    arguments: {'gender': gender},
  );
}
