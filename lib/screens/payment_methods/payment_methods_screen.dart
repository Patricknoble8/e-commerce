import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/payment_method.dart';
import '../../providers/notifiers/profile_notifier.dart';
import '../../widgets/common/app_back_button.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentMethodsNotifierProvider);
    final paymentMethods = paymentState.methods;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Payment Methods',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: paymentState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentMethods.isEmpty
          ? const _EmptyPaymentMethods()
          : ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return _PaymentMethodCard(
                  method: method,
                  onSetDefault: () => ref
                      .read(paymentMethodsNotifierProvider.notifier)
                      .setDefaultPaymentMethod(method.id),
                  onDelete: () => ref
                      .read(paymentMethodsNotifierProvider.notifier)
                      .removePaymentMethod(method.id),
                );
              },
            ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _PaymentMethodCard({
    required this.method,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(
          color: method.isDefault ? AppColors.primary : AppColors.border,
          width: method.isDefault ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Card Icon
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  _getPaymentIcon(method.type),
                  size: 24,
                  color: AppColors.foreground,
                ),
              ),
              SizedBox(width: AppSpacing.md),

              // Card Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          method.name,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.foreground,
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                        if (method.isDefault) ...[
                          SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              'Default',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (method.cardNumber != null) ...[
                      SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        '•••• ${method.cardNumber}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                    ],
                    if (method.expiryDate != null) ...[
                      SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        'Expires ${method.expiryDate}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // More Options
              PopupMenuButton(
                tooltip: 'Payment method actions',
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.foregroundSecondary,
                ),
                onSelected: (action) {
                  if (action == 'default') onSetDefault();
                  if (action == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  if (!method.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Text('Set as Default'),
                    ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance;
      case 'apple_pay':
        return Icons.apple;
      case 'google_pay':
        return Icons.g_mobiledata;
      default:
        return Icons.payment;
    }
  }
}

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods();

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.credit_card_off_outlined,
              size: 48,
              color: AppColors.foregroundSecondary,
            ),
            SizedBox(height: AppSpacing.md),
            Text('No saved payment methods', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Payment methods will appear here after they are securely added through your payment provider.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
