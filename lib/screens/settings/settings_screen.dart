import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notifiers/theme_notifier.dart';
import '../../widgets/common/app_back_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildThemeOption(
                  context,
                  ref,
                  title: 'Light',
                  subtitle: 'Always use light mode',
                  icon: Icons.light_mode,
                  isSelected: themeMode == AppThemeMode.light,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setThemeMode(AppThemeMode.light);
                  },
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _buildThemeOption(
                  context,
                  ref,
                  title: 'Dark',
                  subtitle: 'Always use dark mode',
                  icon: Icons.dark_mode,
                  isSelected: themeMode == AppThemeMode.dark,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setThemeMode(AppThemeMode.dark);
                  },
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _buildThemeOption(
                  context,
                  ref,
                  title: 'System',
                  subtitle: 'Follow system settings',
                  icon: Icons.settings_suggest,
                  isSelected: themeMode == AppThemeMode.system,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setThemeMode(AppThemeMode.system);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notifications section
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildSwitchOption(
                  context,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  icon: Icons.notifications_outlined,
                  value: _pushNotifications,
                  onChanged: (value) =>
                      setState(() => _pushNotifications = value),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _buildSwitchOption(
                  context,
                  title: 'Order Updates',
                  subtitle: 'Get notified about order status',
                  icon: Icons.local_shipping_outlined,
                  value: _orderUpdates,
                  onChanged: (value) => setState(() => _orderUpdates = value),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _buildSwitchOption(
                  context,
                  title: 'Promotional Offers',
                  subtitle: 'Receive deals and discounts',
                  icon: Icons.local_offer_outlined,
                  value: _promotionalOffers,
                  onChanged: (value) =>
                      setState(() => _promotionalOffers = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Application section
          Text(
            'Application',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildListTile(
                  context,
                  title: 'About',
                  icon: Icons.info_outline,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'E-Commerce',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.shopping_bag,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Version info
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      title: Text(title),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: onTap,
    );
  }
}
