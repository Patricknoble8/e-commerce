import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/review.dart';
import 'star_rating.dart';
import 'review_image_gallery.dart';

/// Review card widget with all features
class ReviewCard extends StatefulWidget {
  final Review review;
  final VoidCallback? onHelpfulTap;
  final VoidCallback? onReportTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final bool isCurrentUserReview;
  final String? currentUserId;

  const ReviewCard({
    super.key,
    required this.review,
    this.onHelpfulTap,
    this.onReportTap,
    this.onEditTap,
    this.onDeleteTap,
    this.isCurrentUserReview = false,
    this.currentUserId,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _helpfulAnimationController;
  late Animation<double> _helpfulScaleAnimation;
  bool _isHelpfulAnimating = false;

  @override
  void initState() {
    super.initState();
    _helpfulAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _helpfulScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _helpfulAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _helpfulAnimationController.dispose();
    super.dispose();
  }

  void _handleHelpfulTap() {
    if (_isHelpfulAnimating) return;

    setState(() {
      _isHelpfulAnimating = true;
    });

    HapticFeedback.lightImpact();
    _helpfulAnimationController.forward().then((_) {
      _helpfulAnimationController.reset();
      setState(() {
        _isHelpfulAnimating = false;
      });
    });

    widget.onHelpfulTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    final hasMarkedHelpful =
        widget.currentUserId != null &&
        widget.review.hasUserMarkedHelpful(widget.currentUserId!);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating, Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              _buildAvatar(),
              SizedBox(width: AppSpacing.sm),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.review.userName,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.foreground,
                          ),
                        ),
                        if (widget.review.isVerifiedPurchase) ...[
                          SizedBox(width: AppSpacing.xs),
                          _buildVerifiedBadge(),
                        ],
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        StarRating(rating: widget.review.rating, size: 14),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          widget.review.relativeTime,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.foregroundSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu button
              if (widget.isCurrentUserReview || widget.onReportTap != null)
                _buildMenuButton(),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Review title
          if (widget.review.title.isNotEmpty) ...[
            Text(
              widget.review.title,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
          ],

          // Review comment
          Text(
            widget.review.comment,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
              height: 1.5,
            ),
          ),

          // Images
          if (widget.review.images.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            ReviewImageThumbnails(
              images: widget.review.images,
              onTap: (index) => _showImageGallery(context, index),
            ),
          ],

          SizedBox(height: AppSpacing.sm),

          // Footer: Helpful button
          Row(
            children: [
              _buildHelpfulButton(hasMarkedHelpful),
              const Spacer(),
              if (widget.review.updatedAt != null)
                Text(
                  'Edited',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.foregroundMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: widget.review.userAvatarUrl != null
          ? ClipOval(
              child: Image.network(
                widget.review.userAvatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildAvatarFallback(),
              ),
            )
          : _buildAvatarFallback(),
    );
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Text(
        widget.review.userName.isNotEmpty
            ? widget.review.userName[0].toUpperCase()
            : '?',
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.foregroundSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 12, color: AppColors.success),
          SizedBox(width: 2),
          Text(
            'Verified',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.success,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.foregroundSecondary,
        size: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      itemBuilder: (context) => [
        if (widget.isCurrentUserReview) ...[
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 18),
                SizedBox(width: AppSpacing.sm),
                Text('Edit review'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outlined, size: 18, color: AppColors.error),
                SizedBox(width: AppSpacing.sm),
                Text('Delete review', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),
        ] else ...[
          PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, size: 18),
                SizedBox(width: AppSpacing.sm),
                Text('Report review'),
              ],
            ),
          ),
        ],
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            widget.onEditTap?.call();
            break;
          case 'delete':
            widget.onDeleteTap?.call();
            break;
          case 'report':
            widget.onReportTap?.call();
            break;
        }
      },
    );
  }

  Widget _buildHelpfulButton(bool hasMarkedHelpful) {
    return ScaleTransition(
      scale: _helpfulScaleAnimation,
      child: Material(
        color: hasMarkedHelpful
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: widget.onHelpfulTap != null ? _handleHelpfulTap : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasMarkedHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 16,
                  color: hasMarkedHelpful
                      ? AppColors.primary
                      : AppColors.foregroundSecondary,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Helpful (${widget.review.helpfulCount})',
                  style: AppTypography.labelSmall.copyWith(
                    color: hasMarkedHelpful
                        ? AppColors.primary
                        : AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return ReviewImageGallery(
            images: widget.review.images,
            initialIndex: initialIndex,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

/// Review image thumbnails
class ReviewImageThumbnails extends StatelessWidget {
  final List<String> images;
  final Function(int) onTap;
  final double size;
  final int maxDisplay;

  const ReviewImageThumbnails({
    super.key,
    required this.images,
    required this.onTap,
    this.size = 60,
    this.maxDisplay = 4,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    final displayCount = images.length > maxDisplay
        ? maxDisplay
        : images.length;
    final remaining = images.length - maxDisplay;

    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayCount,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final isLast = index == maxDisplay - 1 && remaining > 0;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md - 1),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.backgroundMuted,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.foregroundMuted,
                        ),
                      ),
                    ),
                    if (isLast)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            '+$remaining',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
