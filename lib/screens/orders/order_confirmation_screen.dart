import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/order.dart';
import '../../widgets/buttons/buttons.dart';
import 'order_detail_screen.dart';

/// Order confirmation screen shown after successful checkout
class OrderConfirmationScreen extends ConsumerWidget {
  final Order order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xl),

              // Success animation
              _buildSuccessIcon(),
              SizedBox(height: AppSpacing.lg),

              // Thank you message
              Text(
                'Thank You!',
                style: AppTypography.h2.copyWith(
                  color: AppColors.foreground,
                  fontWeight: AppTypography.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Your order has been placed successfully',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),

              // Order info card
              _buildOrderInfoCard(),
              SizedBox(height: AppSpacing.lg),

              // Order summary
              _buildOrderSummary(),
              SizedBox(height: AppSpacing.lg),

              // Delivery info
              _buildDeliveryInfo(),
              SizedBox(height: AppSpacing.xl),

              // Action buttons
              _buildActionButtons(context),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Number',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Text(
                order.orderNumber,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Date',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(order.createdAt),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.statusDisplayName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          SizedBox(height: AppSpacing.md),

          // Items count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Text(
                '\$${order.subtotal.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Text(
                '\$${order.shippingCost.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              Text(
                '\$${order.tax.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),

          if (order.discount > 0) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: AppTypography.bodySmall.copyWith(color: Colors.green),
                ),
                Text(
                  '-\$${order.discount.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.green,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.border),
          SizedBox(height: AppSpacing.md),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foreground,
                  fontWeight: AppTypography.bold,
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTypography.h4.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            color: AppColors.primary,
            size: 32,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Delivery',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  order.estimatedDelivery != null
                      ? DateFormat(
                          'EEEE, MMM dd, yyyy',
                        ).format(order.estimatedDelivery!)
                      : 'Within 5-7 business days',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: 'View Order Details',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(orderId: order.id),
              ),
            );
          },
          fullWidth: true,
        ),
        SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Continue Shopping',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
