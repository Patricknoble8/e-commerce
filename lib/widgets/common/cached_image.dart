import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

/// Optimized network image widget with loading states
/// Uses Flutter's built-in Image.network with fade animation
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: child,
          );
        }
        return placeholder ?? _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildErrorWidget(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: _muted,
      child: ShimmerLoading(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        borderRadius: 0,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: _muted,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: _mutedForeground,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            'Image unavailable',
            style: TextStyle(fontSize: 10, color: _mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// Product image with optimized loading
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: borderRadius,
      fit: BoxFit.cover,
    );
  }
}

/// Hero/Banner image with optimized loading
class BannerImage extends StatelessWidget {
  final String imageUrl;
  final double? height;

  const BannerImage({super.key, required this.imageUrl, this.height});

  @override
  Widget build(BuildContext context) {
    return OptimizedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
