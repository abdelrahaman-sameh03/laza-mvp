class AppRoutes {
  AppRoutes._();

  // onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';

  // auth
  static const String authGate = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String reset = '/reset';
  static const String newPassword = '/new-password';
  static const String verificationCode = '/verification-code';

  // main
  static const String shell = '/shell';

  // product
  static const String productDetails = '/product-details';

  // checkout
  static const String payment = '/payment';
  static const String address = '/address';
  static const String orderConfirmed = '/order-confirmed';
  static const String checkoutSuccess = '/checkout-success';

  // reviews
  static const String reviews = '/reviews';
  static const String addReview = '/add-review';

  // orders
  static const String orders = '/orders';
}
