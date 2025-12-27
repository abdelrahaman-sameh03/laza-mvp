import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _CircleBack(onTap: () => Navigator.pop(context)),
              ),
              const SizedBox(height: 24),
              const Text(
                'New Password',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 34),
              _Field(
                label: 'Password',
                controller: _pass,
                obscure: _obscure1,
                onToggle: () => setState(() => _obscure1 = !_obscure1),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Confirm Password',
                controller: _confirm,
                obscure: _obscure2,
                onToggle: () => setState(() => _obscure2 = !_obscure2),
              ),
              const Spacer(),
              const Text(
                'Please write your new password.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // UI-only page (demo). In a real flow: verify reset code & update password.
                    if (_pass.text.trim().length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password must be at least 6 characters.')),
                      );
                      return;
                    }
                    if (_pass.text.trim() != _confirm.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match.')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password updated (demo).')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _Field({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleBack extends StatelessWidget {
  final VoidCallback onTap;
  const _CircleBack({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
        child: const Icon(Icons.arrow_back, color: Colors.black87),
      ),
    );
  }
}
