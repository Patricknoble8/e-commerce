/// API Configuration for E-Commerce App
/// Configure your Node.js + Express backend URLs here
class ApiConfig {
  // ============ Environment ============

  /// Set to true for production, false for development
  static const bool isProduction = false;

  // ============ Base URLs ============

  /// Production API URL - Your deployed backend
  static const String prodUrl = 'https://your-api.com/api/v1';

  /// Development/Local API URL - Your local Express server
  static const String devUrl =
      'http://10.0.2.2:3000/api/v1'; // Android emulator
  // static const String devUrl = 'http://localhost:3000/api/v1'; // iOS simulator / Web
  // static const String devUrl = 'http://YOUR_LOCAL_IP:3000/api/v1'; // Physical device

  /// Current base URL based on environment
  static String get baseUrl => isProduction ? prodUrl : devUrl;

  // ============ Timeouts ============

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============ Health Check ============

  static const String health = '/health';

  // ============ Auth Endpoints ============

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';

  // ============ User/Profile Endpoints ============

  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String uploadAvatar = '/user/avatar';
  static const String deleteAccount = '/user/delete';

  // ============ Address Endpoints ============

  static const String addresses = '/user/addresses';
  static String addressById(String id) => '/user/addresses/$id';

  // ============ Product Endpoints ============

  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String categories = '/categories';
  static const String searchProducts = '/products/search';
  static const String featuredProducts = '/products/featured';
  static const String newArrivals = '/products/new';
  static const String bestsellers = '/products/bestsellers';
  static String productsByCategory(String categoryId) =>
      '/products/category/$categoryId';

  // ============ Cart Endpoints ============

  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update';
  static String removeFromCart(String itemId) => '/cart/remove/$itemId';
  static const String clearCart = '/cart/clear';
  static const String applyCoupon = '/cart/coupon';
  static const String removeCoupon = '/cart/coupon/remove';

  // ============ Order Endpoints ============

  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static const String createOrder = '/orders/create';
  static String cancelOrder(String id) => '/orders/$id/cancel';
  static String trackOrder(String id) => '/orders/$id/track';
  static String reorder(String id) => '/orders/$id/reorder';

  // ============ Wishlist Endpoints ============

  static const String wishlist = '/wishlist';
  static String addToWishlist(String productId) => '/wishlist/add/$productId';
  static String removeFromWishlist(String productId) =>
      '/wishlist/remove/$productId';

  // ============ Review Endpoints ============

  static String productReviews(String productId) =>
      '/products/$productId/reviews';
  static String createReview(String productId) =>
      '/products/$productId/reviews';
  static const String userReviews = '/user/reviews';

  // ============ Payment Endpoints ============

  static const String paymentMethods = '/payments/methods';
  static const String createPaymentIntent = '/payments/create-intent';
  static const String confirmPayment = '/payments/confirm';

  // ============ Notification Endpoints ============

  static const String notifications = '/notifications';
  static const String registerPushToken = '/notifications/register-token';
  static String markNotificationRead(String id) => '/notifications/$id/read';

  // ============ Helper Methods ============

  /// Build full URL from endpoint
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';

  /// Build URL with query parameters
  static String buildUrlWithParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    return uri.toString();
  }
}
