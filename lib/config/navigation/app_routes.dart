abstract final class AppRoutes {
  static const home = '/home';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const categories = '/categories';
  static const notifications = '/notifications';
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const orders = '/orders';
  static const paymentMethods = '/payment-methods';
  static const addresses = '/addresses';
  static const settings = '/settings';
  static const login = '/login';
  static const register = '/register';

  static const protectedRoutes = <String>{
    checkout,
    profile,
    orders,
    paymentMethods,
    addresses,
    settings,
  };
}
