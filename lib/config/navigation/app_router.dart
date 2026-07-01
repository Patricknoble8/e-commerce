import 'package:flutter/material.dart';

import '../../providers/notifiers/auth_notifier.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/categories/categories_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/orders/order_history_screen.dart';
import '../../screens/payment_methods/payment_methods_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/address_management_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AuthState authState,
  ) {
    final routeName = settings.name ?? AppRoutes.home;

    if (AppRoutes.protectedRoutes.contains(routeName) &&
        !authState.isAuthenticated) {
      return _page(settings, LoginScreen(redirectRoute: routeName));
    }

    return switch (routeName) {
      AppRoutes.home => _page(settings, const HomeScreen()),
      AppRoutes.cart => _page(settings, const CartScreen()),
      AppRoutes.checkout => _page(settings, const CheckoutScreen()),
      AppRoutes.categories => _page(settings, const CategoriesScreen()),
      AppRoutes.notifications => _page(settings, const NotificationsScreen()),
      AppRoutes.wishlist => _page(settings, const WishlistScreen()),
      AppRoutes.profile => _page(settings, const ProfileScreen()),
      AppRoutes.orders => _page(settings, const OrderHistoryScreen()),
      AppRoutes.paymentMethods => _page(settings, const PaymentMethodsScreen()),
      AppRoutes.addresses => _page(settings, const AddressManagementScreen()),
      AppRoutes.settings => _page(settings, const SettingsScreen()),
      AppRoutes.login => _page(
        settings,
        LoginScreen(redirectRoute: settings.arguments as String?),
      ),
      AppRoutes.register => _page(
        settings,
        RegisterScreen(redirectRoute: settings.arguments as String?),
      ),
      _ => _page(settings, const _UnknownRouteScreen()),
    };
  }

  static MaterialPageRoute<dynamic> _page(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Return home'),
        ),
      ),
    );
  }
}
