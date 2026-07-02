import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/common/app_back_button.dart';

/// Model for notification preferences
class NotificationPreferences {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool orderUpdates;
  final bool promotions;
  final bool priceAlerts;
  final bool newArrivals;
  final bool restockAlerts;
  final bool reviewReminders;
  final bool weeklyDigest;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.orderUpdates = true,
    this.promotions = true,
    this.priceAlerts = true,
    this.newArrivals = false,
    this.restockAlerts = true,
    this.reviewReminders = true,
    this.weeklyDigest = false,
  });

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? orderUpdates,
    bool? promotions,
    bool? priceAlerts,
    bool? newArrivals,
    bool? restockAlerts,
    bool? reviewReminders,
    bool? weeklyDigest,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      priceAlerts: priceAlerts ?? this.priceAlerts,
      newArrivals: newArrivals ?? this.newArrivals,
      restockAlerts: restockAlerts ?? this.restockAlerts,
      reviewReminders: reviewReminders ?? this.reviewReminders,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
    );
  }
}

/// Provider for notification preferences
final notificationPreferencesProvider =
    StateNotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferences
    >((ref) => NotificationPreferencesNotifier());

class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesNotifier() : super(const NotificationPreferences());

  void togglePush(bool value) => state = state.copyWith(pushEnabled: value);
  void toggleEmail(bool value) => state = state.copyWith(emailEnabled: value);
  void toggleSms(bool value) => state = state.copyWith(smsEnabled: value);
  void toggleOrderUpdates(bool value) =>
      state = state.copyWith(orderUpdates: value);
  void togglePromotions(bool value) =>
      state = state.copyWith(promotions: value);
  void togglePriceAlerts(bool value) =>
      state = state.copyWith(priceAlerts: value);
  void toggleNewArrivals(bool value) =>
      state = state.copyWith(newArrivals: value);
  void toggleRestockAlerts(bool value) =>
      state = state.copyWith(restockAlerts: value);
  void toggleReviewReminders(bool value) =>
      state = state.copyWith(reviewReminders: value);
  void toggleWeeklyDigest(bool value) =>
      state = state.copyWith(weeklyDigest: value);

  void enableAll() {
    state = const NotificationPreferences(
      pushEnabled: true,
      emailEnabled: true,
      smsEnabled: true,
      orderUpdates: true,
      promotions: true,
      priceAlerts: true,
      newArrivals: true,
      restockAlerts: true,
      reviewReminders: true,
      weeklyDigest: true,
    );
  }

  void disableAll() {
    state = const NotificationPreferences(
      pushEnabled: false,
      emailEnabled: false,
      smsEnabled: false,
      orderUpdates: false,
      promotions: false,
      priceAlerts: false,
      newArrivals: false,
      restockAlerts: false,
      reviewReminders: false,
      weeklyDigest: false,
    );
  }
}

/// Notification preferences screen
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppColors.bind(context);
    final prefs = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Notifications',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.foreground),
            onSelected: (value) {
              if (value == 'enable_all') {
                notifier.enableAll();
                _showSnackbar(context, 'All notifications enabled');
              } else if (value == 'disable_all') {
                notifier.disableAll();
                _showSnackbar(context, 'All notifications disabled');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'enable_all',
                child: Text('Enable All'),
              ),
              const PopupMenuItem(
                value: 'disable_all',
                child: Text('Disable All'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Channels
            _buildSectionHeader('Notification Channels'),
            _buildChannelItem(
              context,
              icon: Icons.notifications_active,
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              value: prefs.pushEnabled,
              onChanged: (v) {
                notifier.togglePush(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildChannelItem(
              context,
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: prefs.emailEnabled,
              onChanged: (v) {
                notifier.toggleEmail(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildChannelItem(
              context,
              icon: Icons.sms_outlined,
              title: 'SMS Notifications',
              subtitle: 'Receive text messages',
              value: prefs.smsEnabled,
              onChanged: (v) {
                notifier.toggleSms(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Order Notifications
            _buildSectionHeader('Orders & Shipping'),
            _buildNotificationItem(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'Order Updates',
              subtitle: 'Shipping, delivery, and order status',
              value: prefs.orderUpdates,
              onChanged: (v) {
                notifier.toggleOrderUpdates(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildNotificationItem(
              context,
              icon: Icons.rate_review_outlined,
              title: 'Review Reminders',
              subtitle: 'Reminders to review purchased items',
              value: prefs.reviewReminders,
              onChanged: (v) {
                notifier.toggleReviewReminders(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Deals & Promotions
            _buildSectionHeader('Deals & Promotions'),
            _buildNotificationItem(
              context,
              icon: Icons.local_offer_outlined,
              title: 'Promotions & Deals',
              subtitle: 'Sales, discounts, and special offers',
              value: prefs.promotions,
              onChanged: (v) {
                notifier.togglePromotions(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildNotificationItem(
              context,
              icon: Icons.trending_down,
              title: 'Price Alerts',
              subtitle: 'When items on your wishlist go on sale',
              value: prefs.priceAlerts,
              onChanged: (v) {
                notifier.togglePriceAlerts(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Product Updates
            _buildSectionHeader('Product Updates'),
            _buildNotificationItem(
              context,
              icon: Icons.new_releases_outlined,
              title: 'New Arrivals',
              subtitle: 'New products from brands you follow',
              value: prefs.newArrivals,
              onChanged: (v) {
                notifier.toggleNewArrivals(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildNotificationItem(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Restock Alerts',
              subtitle: 'When out-of-stock items are available',
              value: prefs.restockAlerts,
              onChanged: (v) {
                notifier.toggleRestockAlerts(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildNotificationItem(
              context,
              icon: Icons.newspaper,
              title: 'Weekly Digest',
              subtitle: 'Weekly summary of new products and deals',
              value: prefs.weeklyDigest,
              onChanged: (v) {
                notifier.toggleWeeklyDigest(v);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Quiet Hours
            _buildSectionHeader('Quiet Hours'),
            _buildQuietHoursItem(context),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.foregroundSecondary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChannelItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: AppColors.card,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: value
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                color: value
                    ? AppColors.primary
                    : AppColors.foregroundSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.foregroundSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: AppColors.card,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: value
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: value
                      ? AppColors.primary
                      : AppColors.foregroundSecondary,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foregroundSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuietHoursItem(BuildContext context) {
    return Material(
      color: AppColors.card,
      child: InkWell(
        onTap: () => _showQuietHoursDialog(context),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.bedtime_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiet Hours',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      'No notifications from 10 PM to 7 AM',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foregroundSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.foregroundSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuietHoursDialog(BuildContext context) {
    TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 7, minute: 0);
    bool enabled = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            'Quiet Hours',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Quiet Hours'),
                value: enabled,
                onChanged: (v) => setState(() => enabled = v),
                activeThumbColor: AppColors.primary,
              ),
              if (enabled) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.nightlight_outlined),
                  title: const Text('Start Time'),
                  trailing: Text(
                    startTime.format(context),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (time != null) {
                      setState(() => startTime = time);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wb_sunny_outlined),
                  title: const Text('End Time'),
                  trailing: Text(
                    endTime.format(context),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (time != null) {
                      setState(() => endTime = time);
                    }
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackbar(context, 'Quiet hours updated');
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: AppSpacing.sm),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
