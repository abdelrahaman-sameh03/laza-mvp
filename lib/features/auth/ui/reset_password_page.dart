import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().resetPassword(_email.text);
      if (mounted) {
        UiHelpers.showSnack(context, 'Reset email sent. Check your inbox.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) await UiHelpers.showErrorDialog(context, 'Reset failed', e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFF5F6FA)),
                ),
                const SizedBox(height: 22),
                const Center(child: Text('Forgot Password', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800))),
                const SizedBox(height: 18),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(height: 190, child: Image.asset('assets/figma/Screen 5.png', fit: BoxFit.contain)),
                      const SizedBox(height: 14),
                      const Text('Email Address', style: TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 6),
                      Semantics(
                        label: 'reset_email_field',
                        child: TextFormField(
                          controller: _email,
                          validator: Validators.email,
                          decoration: const InputDecoration(hintText: 'you@example.com', border: UnderlineInputBorder()),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Please write your email to receive a confirmation link to set a new password.',
                        style: TextStyle(color: AppColors.muted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Confirm Mail', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
