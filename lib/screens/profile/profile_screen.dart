import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/navigation/app_routes.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/user.dart';
import '../../providers/notifiers/profile_notifier.dart';
import '../../providers/notifiers/product_notifier.dart';
import '../../providers/notifiers/notifications_notifier.dart';
import '../../providers/notifiers/auth_notifier.dart';
import '../../widgets/common/app_back_button.dart';
import '../../widgets/profile/profile_image_picker.dart';
import '../settings/size_preferences_screen.dart';
import '../settings/security_settings_screen.dart';
import '../settings/notification_preferences_screen.dart';
import '../settings/returns_refunds_screen.dart';
import '../orders/contact_support_screen.dart';
import 'edit_profile_screen.dart';
import '../settings/address_management_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final favoriteCount = ref.watch(favoritesProvider).length;
    final paymentMethods = ref.watch(paymentMethodsProvider);
    final addresses = ref.watch(shippingAddressesProvider);
    final unreadNotifications = ref.watch(unreadCountProvider);
    final activeOrders = ref.watch(activeOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: AppBackButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
              return;
            }

            navigator.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          },
        ),
        title: Text(
          'Profile',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.foreground,
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _ProfileHeader(user: user),
            SizedBox(height: AppSpacing.md),

            // Statistics Card
            _StatisticsCard(
              orders: user.totalOrders,
              reviews: user.totalReviews,
              points: user.loyaltyPoints,
            ),
            SizedBox(height: AppSpacing.lg),

            // Shopping Section
            _SectionHeader(title: 'Shopping'),
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              subtitle: activeOrders > 0
                  ? '$activeOrders active orders'
                  : 'View your past orders',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.orders);
              },
              badge: activeOrders > 0 ? activeOrders.toString() : null,
            ),
            _MenuItem(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              subtitle: '$favoriteCount saved items',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.wishlist);
              },
              badge: favoriteCount > 0 ? favoriteCount.toString() : null,
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              subtitle: '${addresses.length} saved addresses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressManagementScreen(),
                  ),
                );
              },
            ),
            _MenuItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              subtitle: '${paymentMethods.length} saved methods',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.paymentMethods);
              },
            ),
            _MenuItem(
              icon: Icons.assignment_return_outlined,
              title: 'Returns & Refunds',
              subtitle: 'Manage your returns',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReturnsRefundsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Preferences Section
            _SectionHeader(title: 'Preferences'),
            _MenuItem(
              icon: Icons.straighten_outlined,
              title: 'Size Preferences',
              subtitle: 'Save your default sizes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SizePreferencesScreen(),
                  ),
                );
              },
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: unreadNotifications > 0
                  ? '$unreadNotifications unread messages'
                  : 'Manage notifications',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
              badge: unreadNotifications > 0
                  ? unreadNotifications.toString()
                  : null,
            ),
            _MenuItem(
              icon: Icons.email_outlined,
              title: 'Marketing Preferences',
              subtitle: 'Newsletter & promotions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPreferencesScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Account Section
            _SectionHeader(title: 'Account'),
            _MenuItem(
              icon: Icons.lock_outlined,
              title: 'Security & Password',
              subtitle: 'Change your password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecuritySettingsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Support Section
            _SectionHeader(title: 'Support'),
            _MenuItem(
              icon: Icons.support_agent_outlined,
              title: 'Contact Us',
              subtitle: 'Get in touch with support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.xl),

            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Consumer(
                builder: (context, ref, child) {
                  return OutlinedButton(
                    onPressed: () {
                      _showLogoutDialog(context, ref);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.destructive,
                      side: const BorderSide(color: AppColors.destructive),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.destructive,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Logout',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.foregroundSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              );
            },
            child: Text(
              'Logout',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          // Avatar with image picker
          const ProfileImagePicker(size: 64, editable: true),
          SizedBox(width: AppSpacing.md),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.foreground,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getMembershipColor(
                          user.membershipTier,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: _getMembershipColor(
                            user.membershipTier,
                          ).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        user.membershipTier,
                        style: AppTypography.labelSmall.copyWith(
                          color: _getMembershipColor(user.membershipTier),
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs / 2),
                Text(
                  user.email,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.foregroundSecondary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getMembershipColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return const Color(0xFF94A3B8);
      case 'gold':
        return const Color(0xFFEAB308);
      case 'silver':
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFFCD7F32);
    }
  }
}

class _StatisticsCard extends StatelessWidget {
  final int orders;
  final int reviews;
  final int points;

  const _StatisticsCard({
    required this.orders,
    required this.reviews,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: orders.toString(),
            label: 'Orders',
            icon: Icons.shopping_bag_outlined,
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          _StatItem(
            value: reviews.toString(),
            label: 'Reviews',
            icon: Icons.star_outline,
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          _StatItem(
            value: '${points}pts',
            label: 'Points',
            icon: Icons.stars_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: AppColors.foreground,
            fontWeight: AppTypography.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs / 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.foregroundSecondary,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.foreground,
          fontWeight: AppTypography.semiBold,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 20, color: AppColors.foregroundSecondary),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: AppTypography.medium,
              ),
            ),
            if (badge != null) ...[
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryForeground,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: AppSpacing.xs / 2),
          child: Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.foregroundSecondary,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.foregroundSecondary,
          size: 20,
        ),
      ),
    );
  }
}
