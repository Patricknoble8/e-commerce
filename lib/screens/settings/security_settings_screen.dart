import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';

/// Security settings screen for password and security options
class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  bool _loginAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Security & Password',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Password Section
            _buildSectionHeader('Password'),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Last changed 30 days ago',
              onTap: () => _showChangePasswordDialog(context),
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Authentication Section
            _buildSectionHeader('Authentication'),
            _buildSwitchItem(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID to login',
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() => _biometricEnabled = value);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildSwitchItem(
              icon: Icons.security,
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security to your account',
              value: _twoFactorEnabled,
              onChanged: (value) {
                if (value) {
                  _showSetup2FADialog(context);
                } else {
                  setState(() => _twoFactorEnabled = false);
                }
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Privacy Section
            _buildSectionHeader('Privacy & Alerts'),
            _buildSwitchItem(
              icon: Icons.notifications_active_outlined,
              title: 'Login Alerts',
              subtitle: 'Get notified of new logins',
              value: _loginAlerts,
              onChanged: (value) {
                setState(() => _loginAlerts = value);
                HapticFeedback.selectionClick();
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildMenuItem(
              icon: Icons.devices,
              title: 'Active Sessions',
              subtitle: '2 devices logged in',
              onTap: () => _showActiveSessionsSheet(context),
            ),
            const Divider(height: 1, indent: 56),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Login History',
              subtitle: 'View recent login activity',
              onTap: () => _showLoginHistorySheet(context),
            ),
            const Divider(height: 1, indent: 56),

            SizedBox(height: AppSpacing.lg),

            // Danger Zone
            _buildSectionHeader('Account Actions'),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Sign Out All Devices',
              subtitle: 'Log out from all other devices',
              onTap: () => _showSignOutAllDialog(context),
              iconColor: AppColors.warning,
            ),
            const Divider(height: 1, indent: 56),
            _buildMenuItem(
              icon: Icons.delete_forever,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () => _showDeleteAccountDialog(context),
              iconColor: AppColors.destructive,
              textColor: AppColors.destructive,
            ),

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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: AppColors.card,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
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
                        color: textColor ?? AppColors.foreground,
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
              Icon(Icons.chevron_right, color: AppColors.foregroundSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
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
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            'Change Password',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordField(
                  controller: currentPasswordController,
                  label: 'Current Password',
                  obscure: obscureCurrent,
                  onToggle: () =>
                      setDialogState(() => obscureCurrent = !obscureCurrent),
                ),
                SizedBox(height: AppSpacing.md),
                _buildPasswordField(
                  controller: newPasswordController,
                  label: 'New Password',
                  obscure: obscureNew,
                  onToggle: () =>
                      setDialogState(() => obscureNew = !obscureNew),
                ),
                SizedBox(height: AppSpacing.md),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  label: 'Confirm New Password',
                  obscure: obscureConfirm,
                  onToggle: () =>
                      setDialogState(() => obscureConfirm = !obscureConfirm),
                ),
                SizedBox(height: AppSpacing.sm),
                _buildPasswordRequirements(),
              ],
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
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackbar('Password changed successfully');
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.foregroundSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          _buildRequirement('At least 8 characters'),
          _buildRequirement('One uppercase letter'),
          _buildRequirement('One number'),
          _buildRequirement('One special character'),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs / 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
          SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.foregroundSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showSetup2FADialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Enable 2FA',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.qr_code_2,
                size: 120,
                color: AppColors.foreground,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Scan this QR code with your authenticator app',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter verification code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _twoFactorEnabled = true);
              Navigator.pop(context);
              _showSuccessSnackbar('Two-factor authentication enabled');
            },
            child: const Text('Verify & Enable'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Active Sessions',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.md),
            _buildSessionItem(
              'iPhone 15 Pro',
              'Current device',
              Icons.phone_iphone,
              isCurrentDevice: true,
            ),
            const Divider(),
            _buildSessionItem(
              'MacBook Pro',
              'Last active 2 hours ago',
              Icons.laptop_mac,
            ),
            SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              text: 'Sign Out Other Devices',
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackbar('Signed out from other devices');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(
    String device,
    String status,
    IconData icon, {
    bool isCurrentDevice = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: AppColors.foreground),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: AppTypography.labelLarge),
                Text(
                  status,
                  style: AppTypography.bodySmall.copyWith(
                    color: isCurrentDevice
                        ? AppColors.success
                        : AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentDevice)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                'This device',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showLoginHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Login History',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.md),
            _buildLoginHistoryItem(
              'Today, 10:30 AM',
              'iPhone 15 Pro',
              'New York, US',
            ),
            const Divider(),
            _buildLoginHistoryItem(
              'Yesterday, 3:45 PM',
              'MacBook Pro',
              'New York, US',
            ),
            const Divider(),
            _buildLoginHistoryItem(
              'Jan 10, 2026',
              'Chrome Browser',
              'New York, US',
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginHistoryItem(String date, String device, String location) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.login, color: AppColors.foregroundSecondary),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: AppTypography.labelMedium),
                Text(
                  '$device • $location',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Sign Out All Devices'),
        content: const Text(
          'This will sign you out from all devices except this one. You will need to log in again on other devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('Signed out from all other devices');
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Sign Out All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Delete Account',
          style: AppTypography.h4.copyWith(color: AppColors.destructive),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
            ),
            SizedBox(height: AppSpacing.md),
            Text('This will:', style: AppTypography.labelMedium),
            SizedBox(height: AppSpacing.xs),
            _buildDeleteWarning('Delete all your orders and history'),
            _buildDeleteWarning('Remove saved payment methods'),
            _buildDeleteWarning('Cancel any active subscriptions'),
            _buildDeleteWarning('Permanently delete your profile'),
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
              // Handle account deletion
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.destructive,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteWarning(String text) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.remove_circle_outline,
            size: 16,
            color: AppColors.destructive,
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
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
