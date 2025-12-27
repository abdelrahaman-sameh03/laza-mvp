import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../app/router/app_routes.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().signUp(_name.text, _email.text, _password.text);
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.shell);
    } catch (e) {
      if (mounted) await UiHelpers.showErrorDialog(context, 'Signup failed', e);
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
                const Center(child: Text('Sign Up', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800))),
                const SizedBox(height: 30),

                const Text('Username', style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 6),
                Semantics(
                  label: 'signup_name',
                  child: TextFormField(
                    controller: _name,
                    validator: (v) => Validators.requiredField('Username', v),
                    decoration: const InputDecoration(hintText: 'Your name', border: UnderlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 18),

                const Text('Email Address', style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 6),
                Semantics(
                  label: 'signup_email',
                  child: TextFormField(
                    controller: _email,
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'you@example.com', border: UnderlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 18),

                const Text('Password', style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 6),
                Semantics(
                  label: 'signup_password',
                  child: TextFormField(
                    controller: _password,
                    validator: Validators.password,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: '******', border: UnderlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remember me'),
                    Switch(value: _remember, onChanged: (v) => setState(() => _remember = v), activeThumbColor: Colors.green),
                  ],
                ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: Semantics(
                    label: 'signup_btn',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Semantics(
                    label: 'go_to_login_btn',
                    button: true,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: const Text('Already have an account? Signin'),
                    ),
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
