import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/product.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/common/common_widgets.dart';
import '../../providers/providers.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedColor;
  int? _selectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableColors.isNotEmpty) {
      _selectedColor = widget.product.availableColors[0];
    }
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes[0];
    }
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
          'Product details',
          style: AppTypography.h4.copyWith(
            color: AppColors.foreground,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.foreground,
            ),
            onPressed: () {},
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with 360 slider
                  _buildProductImage(),
                  
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.foreground,
                                ),
                              ),
                            ),
                            Text(
                              '\$${widget.product.finalPrice.toStringAsFixed(0)}',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppTypography.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md),

                        // Color Selection
                        _buildColorSelection(),
                        SizedBox(height: AppSpacing.md),

                        // Size Selection
                        _buildSizeSelection(),
                        SizedBox(height: AppSpacing.md),

                        const DividerComponent(),
                        SizedBox(height: AppSpacing.md),

                        // About Section
                        Text(
                          'About',
                          style: AppTypography.h4.copyWith(
                            color: AppColors.foreground,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.product.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.foregroundSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Action Buttons
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 320,
      width: double.infinity,
      color: AppColors.backgroundMuted,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              widget.product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: AppColors.mutedForeground,
                );
              },
            ),
          ),
          // 360 degree indicator
          Positioned(
            bottom: AppSpacing.md,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.threesixty,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '360° View',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.foreground,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: widget.product.availableColors.map((colorName) {
            return ColorSelector(
              color: _getColorFromName(colorName),
              isSelected: _selectedColor == colorName,
              onTap: () {
                setState(() {
                  _selectedColor = colorName;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.foreground,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: widget.product.availableSizes.map((size) {
            return SizeSelector(
              size: size.toString(),
              isSelected: _selectedSize == size,
              onTap: () {
                setState(() {
                  _selectedSize = size;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: AppBorderWidth.thin,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              SecondaryButton(
                text: 'Order Now',
                onPressed: () {},
                icon: Icons.shopping_bag_outlined,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  text: 'Add to card',
                  onPressed: () {
                    if (_selectedColor != null && _selectedSize != null) {
                      ref.read(cartProvider.notifier).addToCart(
                            widget.product,
                            _selectedColor!,
                            _selectedSize!,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added to cart',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
