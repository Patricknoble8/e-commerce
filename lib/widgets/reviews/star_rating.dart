import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';

/// Star rating display widget with half-star support
class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showValue;
  final MainAxisAlignment alignment;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
    this.showValue = false,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          IconData icon;
          Color color;

          if (rating >= starValue) {
            icon = Icons.star_rounded;
            color = activeColor ?? const Color(0xFFFACC15);
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
            color = activeColor ?? const Color(0xFFFACC15);
          } else {
            icon = Icons.star_outline_rounded;
            color = inactiveColor ?? AppColors.border;
          }

          return Icon(icon, size: size, color: color);
        }),
        if (showValue) ...[
          SizedBox(width: AppSpacing.xs),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
        ],
      ],
    );
  }
}

/// Interactive star rating for input
class StarRatingInput extends StatefulWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;
  final bool allowHalfRating;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 40,
    this.allowHalfRating = true,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(StarRatingInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  void _handleTap(int index, Offset localPosition) {
    final starWidth = widget.size;
    final isLeftHalf = localPosition.dx < starWidth / 2;

    double newRating;
    if (widget.allowHalfRating && isLeftHalf) {
      newRating = index + 0.5;
    } else {
      newRating = (index + 1).toDouble();
    }

    setState(() {
      _currentRating = newRating;
    });
    widget.onRatingChanged(newRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        Color color;

        if (_currentRating >= starValue) {
          icon = Icons.star_rounded;
          color = widget.activeColor ?? const Color(0xFFFACC15);
        } else if (_currentRating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
          color = widget.activeColor ?? const Color(0xFFFACC15);
        } else {
          icon = Icons.star_outline_rounded;
          color = widget.inactiveColor ?? AppColors.border;
        }

        return GestureDetector(
          onTapDown: (details) => _handleTap(index, details.localPosition),
          child: AnimatedScale(
            scale: _currentRating >= starValue - 0.5 ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Icon(icon, size: widget.size, color: color),
          ),
        );
      }),
    );
  }
}

/// Rating distribution bar chart
class RatingDistribution extends StatelessWidget {
  final Map<int, int> distribution;
  final int totalReviews;
  final double averageRating;
  final ValueChanged<int?>? onRatingFilterTap;
  final int? selectedRating;

  const RatingDistribution({
    super.key,
    required this.distribution,
    required this.totalReviews,
    required this.averageRating,
    this.onRatingFilterTap,
    this.selectedRating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Average rating
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
                height: 1,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            StarRating(rating: averageRating, size: 16),
            SizedBox(height: AppSpacing.xs),
            Text(
              '$totalReviews reviews',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
        SizedBox(width: AppSpacing.lg),
        // Right side - Distribution bars
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final rating = 5 - index;
              final count = distribution[rating] ?? 0;
              final percentage = totalReviews > 0
                  ? (count / totalReviews)
                  : 0.0;
              final isSelected = selectedRating == rating;

              return GestureDetector(
                onTap: onRatingFilterTap != null
                    ? () => onRatingFilterTap!(isSelected ? null : rating)
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.foregroundSecondary,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: isSelected
                            ? const Color(0xFFFACC15)
                            : AppColors.foregroundSecondary,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundMuted,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: percentage,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFFACC15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.foregroundSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Animated fractionally sized box
class AnimatedFractionallySizedBox extends StatelessWidget {
  final Duration duration;
  final double widthFactor;
  final Widget child;

  const AnimatedFractionallySizedBox({
    super.key,
    required this.duration,
    required this.widthFactor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0, end: widthFactor),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
