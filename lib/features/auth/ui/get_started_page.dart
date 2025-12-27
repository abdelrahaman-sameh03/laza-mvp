import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../providers/auth_provider.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  Future<void> _googleLogin(BuildContext context) async {
    try {
      await context.read<AuthProvider>().loginWithGoogle();
      if (context.mounted) {
        // بعد تسجيل الدخول ودّيه للهوم/الشيل
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (r) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google login failed: $e')),
        );
      }
    }
  }

  void _notImplemented(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name login not implemented in MVP')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Title
              const Text(
                "Let’s Get Started",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Create your account or sign in to continue.",
                style: TextStyle(color: AppColors.muted),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Social buttons (بدون تكرار)
              _SocialButton(
                title: 'Facebook',
                bg: const Color(0xFF4267B2),
                onPressed: () => _notImplemented(context, 'Facebook'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                title: 'Twitter',
                bg: const Color(0xFF1DA1F2),
                onPressed: () => _notImplemented(context, 'Twitter'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                title: 'Google',
                bg: const Color(0xFFEA4335),
                onPressed: () => _googleLogin(context),
              ),

              const Spacer(),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: Semantics(
                      label: 'go_to_login_btn',
                      button: true,
                      child: Text(
                        'Signin',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Create account
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Semantics(
                  label: 'go_to_signup_btn',
                  button: true,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
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

class _SocialButton extends StatelessWidget {
  final String title;
  final Color bg;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.title,
    required this.bg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
