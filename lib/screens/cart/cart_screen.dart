import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/navigation/app_routes.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/common/common_widgets.dart';
import '../../widgets/common/app_back_button.dart';
import '../../providers/providers.dart';
import '../../models/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Cart',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.foreground,
            ),
            tooltip: 'Notifications',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Builder(
        builder: (context) {
          final cartState = ref.watch(cartProvider);

          if (cartState.items.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        // Cart Items
                        ...cartState.items.map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _buildCartItem(item),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),

                        // Order Summary
                        _buildOrderSummary(),
                      ],
                    ),
                  ),
                ),
              ),
              // Checkout Button
              _buildCheckoutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.mutedForeground,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Your cart is empty',
              style: AppTypography.h3.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Add items to get started',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Start Shopping',
              onPressed: () => Navigator.pop(context),
              icon: Icons.shopping_bag_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: AppBorderWidth.thin),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.asset(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: AppColors.mutedForeground,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.medium,
                    color: AppColors.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      'Price: ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foregroundSecondary,
                      ),
                    ),
                    Text(
                      '\$${item.product.finalPrice.toStringAsFixed(0)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foreground,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    // Color indicator
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getColorFromName(item.selectedColor),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          item.selectedSize.toString(),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.foregroundSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Quantity Controls and Delete
          Column(
            children: [
              // Delete button
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).removeFromCart(item);
                },
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              // Quantity controls
              Row(
                children: [
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (item.quantity > 1) {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item, item.quantity - 1);
                      } else {
                        ref.read(cartProvider.notifier).removeFromCart(item);
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      '${item.quantity}',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.add,
                    onTap: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item, item.quantity + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: AppColors.border,
            width: AppBorderWidth.thin,
          ),
        ),
        child: Icon(icon, size: 16, color: AppColors.foreground),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final cartState = ref.watch(cartProvider);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: AppBorderWidth.thin),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Sub Total',
            '\$${cartState.subtotal.toStringAsFixed(0)}',
          ),
          SizedBox(height: AppSpacing.sm),
          _buildSummaryRow(
            'Delivery Charge',
            '\$${cartState.deliveryCharge.toStringAsFixed(0)}',
          ),
          SizedBox(height: AppSpacing.sm),
          const DividerComponent(),
          SizedBox(height: AppSpacing.sm),
          _buildSummaryRow(
            'Total',
            '\$${cartState.total.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.foregroundSecondary,
            fontWeight: isBold ? AppTypography.semiBold : AppTypography.regular,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.foreground,
            fontWeight: isBold ? AppTypography.bold : AppTypography.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: AppBorderWidth.thin),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            text: 'Proceed To Checkout',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.checkout);
            },
            fullWidth: true,
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return const Color(0xFF2563EB);
      case 'white':
        return const Color(0xFFFFFFFF);
      case 'orange':
        return const Color(0xFFF97316);
      case 'sky blue':
        return const Color(0xFF38BDF8);
      case 'red':
        return const Color(0xFFEF4444);
      case 'black':
        return const Color(0xFF0F172A);
      default:
        return const Color(0xFF64748B);
    }
  }
}
