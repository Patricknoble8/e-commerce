import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme/theme.dart';
import 'providers/notifiers/theme_notifier.dart';
import 'providers/notifiers/auth_notifier.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/payment_methods/payment_methods_screen.dart';
import 'screens/orders/order_history_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: _buildHome(authState),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/orders': (context) => const OrderHistoryScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }

  Widget _buildHome(AuthState authState) {
    // Show loading while checking auth status
    if (authState.status == AuthStatus.initial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show login screen if not authenticated
    if (authState.status == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    // Show home screen if authenticated
    return const HomeScreen();
  }
}
