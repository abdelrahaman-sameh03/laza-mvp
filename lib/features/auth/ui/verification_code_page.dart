import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  int _seconds = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    super.dispose();
  }

  String get _code => '${_c1.text}${_c2.text}${_c3.text}${_c4.text}';

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
              const SizedBox(height: 10),
              const Text(
                'Verification Code',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),

              // Illustration (simple, no extra assets)
              Expanded(
                child: Center(
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.cloud_outlined, size: 160, color: AppColors.primary),
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD54F),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.lock_outline, size: 46, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DigitBox(controller: _c1, autoNext: true),
                  _DigitBox(controller: _c2, autoNext: true),
                  _DigitBox(controller: _c3, autoNext: true),
                  _DigitBox(controller: _c4, autoNext: false),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '00:${_seconds.toString().padLeft(2, '0')} resend confirmation code.',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 18),
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
                    if (_code.length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter the 4-digit code.')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Code confirmed: $_code (demo)')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Confirm Code',
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

class _DigitBox extends StatelessWidget {
  final TextEditingController controller;
  final bool autoNext;
  const _DigitBox({required this.controller, required this.autoNext});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && autoNext) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
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
