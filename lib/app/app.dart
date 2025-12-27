import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/catalog/providers/products_provider.dart';
import '../features/cart/providers/cart_provider.dart';
import '../features/favorites/providers/favorites_provider.dart';
import '../features/orders/providers/orders_provider.dart';

import '../features/auth/ui/auth_gate.dart';
import '../features/auth/ui/login_page.dart';
import '../features/auth/ui/get_started_page.dart';
import '../features/auth/ui/signup_page.dart';
import '../features/auth/ui/reset_password_page.dart';
import '../features/auth/ui/new_password_page.dart';
import '../features/auth/ui/verification_code_page.dart';

import '../features/catalog/ui/main_shell.dart';
import '../features/catalog/ui/product_details_page.dart';

import '../features/checkout/ui/payment_page.dart';
import '../features/checkout/ui/address_page.dart';
import '../features/checkout/ui/order_confirmed_page.dart';

import '../features/reviews/ui/reviews_page.dart';
import '../features/reviews/ui/add_review_page.dart';

import '../features/cart/ui/checkout_success_page.dart';

import '../features/onboarding/ui/splash_page.dart';
import '../features/onboarding/ui/onboarding_page.dart';

import '../features/orders/ui/orders_page.dart';

import 'router/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.primary);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) => cart!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider(),
          update: (_, auth, fav) => fav!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(),
          update: (_, auth, orders) => orders!..setUser(auth.userId),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: AppColors.bg,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.getStarted: (context) => const GetStartedPage(),
          AppRoutes.splash: (_) => const SplashPage(),
          AppRoutes.onboarding: (_) => const OnboardingPage(),
          AppRoutes.authGate: (_) => const AuthGate(),
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.signup: (_) => const SignupPage(),
          AppRoutes.reset: (_) => const ResetPasswordPage(),
          AppRoutes.newPassword: (_) => const NewPasswordPage(),
          AppRoutes.verificationCode: (_) => const VerificationCodePage(),
          AppRoutes.shell: (_) => const MainShell(),
          AppRoutes.payment: (_) => const PaymentPage(),
          AppRoutes.address: (_) => const AddressPage(),
          AppRoutes.orderConfirmed: (_) => const OrderConfirmedPage(),
          AppRoutes.reviews: (_) => const ReviewsPage(),
          AppRoutes.addReview: (_) => const AddReviewPage(),
          AppRoutes.orders: (_) => const OrdersPage(),
          // legacy route (kept for compatibility)
          AppRoutes.checkoutSuccess: (_) => const CheckoutSuccessPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.productDetails) {
            final productId = settings.arguments as int;
            return MaterialPageRoute(builder: (_) => ProductDetailsPage(productId: productId));
          }
          return null;
        },
      ),
    );
  }
}
