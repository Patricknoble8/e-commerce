import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/navigation/app_routes.dart';
import '../../providers/providers.dart';

/// Professional app drawer with shadcn/ui styling
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  // shadcn/ui inspired color palette
  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);
  static const Color _border = Color(0xFFE4E4E7);
  static const Color _primary = Color(0xFF18181B);
  static const Color _destructive = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProvider);
    final cartItemCount = ref.watch(cartProvider).itemCount;
    final favorites = ref.watch(favoritesProvider);

    return Drawer(
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(0)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with user profile
            _buildHeader(context, profile),

            Divider(height: 1, color: _border),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.category_rounded,
                    label: 'Categories',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.categories);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.shopping_bag_rounded,
                    label: 'Cart',
                    badge: cartItemCount > 0 ? cartItemCount.toString() : null,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite_rounded,
                    label: 'Wishlist',
                    badge: favorites.isNotEmpty
                        ? favorites.length.toString()
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.wishlist);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Divider(height: 1, color: _border),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.person_rounded,
                    label: 'My Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.receipt_long_rounded,
                    label: 'Order History',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.orders);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.credit_card_rounded,
                    label: 'Payment Methods',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.paymentMethods);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.location_on_rounded,
                    label: 'Addresses',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.addresses);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Divider(height: 1, color: _border),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),
                ],
              ),
            ),

            // Footer
            _buildFooter(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _primary,
              shape: BoxShape.circle,
              border: Border.all(color: _border, width: 2),
            ),
            child: Center(
              child: Text(
                _getInitials(profile.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name.isNotEmpty ? profile.name : 'Guest User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email.isNotEmpty
                      ? profile.email
                      : 'Sign in to continue',
                  style: TextStyle(fontSize: 13, color: _mutedForeground),
                ),
              ],
            ),
          ),

          // Edit button
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            icon: Icon(Icons.edit_rounded, color: _mutedForeground, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: _muted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _muted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _foreground, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _foreground,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _destructive,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _mutedForeground,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Column(
        children: [
          // App version
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Luxe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _foreground,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(fontSize: 12, color: _mutedForeground),
          ),
          const SizedBox(height: 16),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showLogoutDialog(context, ref);
              },
              icon: Icon(Icons.logout_rounded, size: 18, color: _destructive),
              label: Text(
                'Sign Out',
                style: TextStyle(
                  color: _destructive,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: _border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'G';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _foreground,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontSize: 14, color: _mutedForeground),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: _mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              navigator.pop();
              await ref.read(authProvider.notifier).signOut();
              navigator.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
              messenger.showSnackBar(
                SnackBar(
                  content: const Text('Signed out successfully'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: _destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
