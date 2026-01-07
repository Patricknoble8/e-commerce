import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../providers/notifiers/profile_notifier.dart';
import '../../providers/notifiers/product_notifier.dart';
import '../../providers/notifiers/notifications_notifier.dart';
import '../notifications/notifications_screen.dart';

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
        title: Text(
          'Profile',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.foreground,
            onPressed: () {},
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
              onTap: () {},
              badge: activeOrders > 0 ? activeOrders.toString() : null,
            ),
            _MenuItem(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              subtitle: '$favoriteCount saved items',
              onTap: () {
                Navigator.pushNamed(context, '/wishlist');
              },
              badge: favoriteCount > 0 ? favoriteCount.toString() : null,
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              subtitle: '${addresses.length} saved addresses',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              subtitle: '${paymentMethods.length} saved methods',
              onTap: () {
                Navigator.pushNamed(context, '/payment-methods');
              },
            ),
            _MenuItem(
              icon: Icons.assignment_return_outlined,
              title: 'Returns & Refunds',
              subtitle: 'Manage your returns',
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.lg),

            // Rewards & Loyalty Section
            _SectionHeader(title: 'Rewards & Loyalty'),
            _MenuItem(
              icon: Icons.stars_outlined,
              title: 'Loyalty Points',
              subtitle: '${user.loyaltyPoints} points available',
              onTap: () {},
              trailing: Text(
                '${user.loyaltyPoints} pts',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
            _MenuItem(
              icon: Icons.card_giftcard_outlined,
              title: 'Coupons & Vouchers',
              subtitle: 'View available discounts',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet',
              subtitle: 'Balance: \$${user.walletBalance.toStringAsFixed(2)}',
              onTap: () {},
              trailing: Text(
                '\$${user.walletBalance.toStringAsFixed(2)}',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
            _MenuItem(
              icon: Icons.share_outlined,
              title: 'Refer & Earn',
              subtitle: 'Share with friends',
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.lg),

            // Preferences Section
            _SectionHeader(title: 'Preferences'),
            _MenuItem(
              icon: Icons.straighten_outlined,
              title: 'Size Preferences',
              subtitle: 'Save your default sizes',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: unreadNotifications > 0
                  ? '$unreadNotifications unread messages'
                  : 'Manage notifications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
              badge: unreadNotifications > 0
                  ? unreadNotifications.toString()
                  : null,
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.email_outlined,
              title: 'Marketing Preferences',
              subtitle: 'Newsletter & promotions',
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.lg),

            // Account Section
            _SectionHeader(title: 'Account'),
            _MenuItem(
              icon: Icons.lock_outlined,
              title: 'Security & Password',
              subtitle: 'Change your password',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () {},
              isDestructive: true,
            ),
            SizedBox(height: AppSpacing.lg),

            // Support Section
            _SectionHeader(title: 'Support'),
            _MenuItem(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Frequently asked questions',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.support_agent_outlined,
              title: 'Contact Us',
              subtitle: 'Get in touch with support',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.headset_mic_outlined,
              title: 'Get Help',
              subtitle: 'Chat with support',
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.xl),

            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: OutlinedButton(
                onPressed: () {},
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
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
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
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                user.name[0].toUpperCase(),
                style: AppTypography.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ),
          ),
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
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: _getMembershipColor(
                            user.membershipTier,
                          ).withOpacity(0.3),
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
            onPressed: () {},
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
  final Widget? trailing;
  final String? badge;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.badge,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
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
            color: isDestructive
                ? AppColors.destructive.withOpacity(0.1)
                : AppColors.muted,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDestructive
                ? AppColors.destructive
                : AppColors.foregroundSecondary,
          ),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isDestructive
                    ? AppColors.destructive
                    : AppColors.foreground,
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
                    color: Colors.white,
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
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right,
              color: AppColors.foregroundSecondary,
              size: 20,
            ),
      ),
    );
  }
}
