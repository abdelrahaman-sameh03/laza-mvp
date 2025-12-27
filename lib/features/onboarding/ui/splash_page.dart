import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Semantics(
        label: 'splash_screen',
        child: Container(
          color: AppColors.primary,
          alignment: Alignment.center,
          child: Image.asset('assets/figma/Splash.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
