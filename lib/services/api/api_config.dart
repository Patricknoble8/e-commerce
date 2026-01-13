/// API Configuration for E-Commerce App
/// Change baseUrl to point to your backend server
class ApiConfig {
  // ============ Base URLs ============

  /// Production API URL
  static const String prodUrl = 'https://your-api.com/api/v1';

  /// Development/Local API URL
  static const String devUrl = 'http://localhost:3000/api/v1';

  /// Current base URL - switch between prod and dev
  static const String baseUrl = devUrl; // Change to prodUrl for production

  // ============ Timeouts ============

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============ API Endpoints ============

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User/Profile
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String uploadAvatar = '/user/avatar';

  // Products
  static const String products = '/products';
  static const String productDetail = '/products'; // + /{id}
  static const String categories = '/categories';
  static const String search = '/products/search';
  static const String featured = '/products/featured';
  static const String newArrivals = '/products/new';
  static const String bestsellers = '/products/bestsellers';

  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCart = '/cart/update';
  static const String removeFromCart = '/cart/remove';
  static const String clearCart = '/cart/clear';

  // Orders
  static const String orders = '/orders';
  static const String createOrder = '/orders';
  static const String orderDetail = '/orders'; // + /{id}
  static const String cancelOrder = '/orders/cancel';
  static const String trackOrder = '/orders/track';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove';

  // Addresses
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses';
  static const String updateAddress = '/addresses'; // + /{id}
  static const String deleteAddress = '/addresses'; // + /{id}
  static const String setDefaultAddress = '/addresses/default';

  // Payment
  static const String paymentMethods = '/payment-methods';
  static const String addPaymentMethod = '/payment-methods';
  static const String deletePaymentMethod = '/payment-methods'; // + /{id}

  // Reviews
  static const String reviews = '/reviews';
  static const String productReviews = '/products'; // + /{id}/reviews
  static const String addReview = '/reviews';

  // Promo Codes
  static const String validatePromo = '/promo/validate';
  static const String applyPromo = '/promo/apply';

  // Notifications
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String notificationSettings = '/notifications/settings';

  // Support
  static const String supportTickets = '/support/tickets';
  static const String createTicket = '/support/tickets';

  // ============ Headers ============

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Platform': 'mobile',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  };
}
