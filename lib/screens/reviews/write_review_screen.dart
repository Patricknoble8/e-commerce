import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/review.dart';
import '../../models/product.dart';
import '../../providers/providers.dart';
import '../../widgets/reviews/star_rating.dart';
import '../../widgets/buttons/buttons.dart';

/// Screen for writing or editing a review
class WriteReviewScreen extends ConsumerStatefulWidget {
  final Product product;
  final Review? existingReview; // For editing

  const WriteReviewScreen({
    super.key,
    required this.product,
    this.existingReview,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();

  double _rating = 0;
  List<String> _images = [];
  bool _isSubmitting = false;

  bool get _isEditing => widget.existingReview != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _rating = widget.existingReview!.rating;
      _titleController.text = widget.existingReview!.title;
      _commentController.text = widget.existingReview!.comment;
      _images = List.from(widget.existingReview!.images);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (!mounted) return;
      if (pickedFiles.isNotEmpty) {
        final reachedLimit = _images.length + pickedFiles.length > 5;
        setState(() {
          _images.addAll(pickedFiles.map((f) => f.path));
          if (_images.length > 5) {
            _images = _images.sublist(0, 5);
          }
        });
        if (reachedLimit) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Maximum 5 images allowed'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to pick images'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final currentUserId = ref.read(currentUserIdProvider);

      if (_isEditing) {
        ref
            .read(reviewProvider.notifier)
            .updateReview(
              widget.existingReview!.id,
              rating: _rating,
              title: _titleController.text.trim(),
              comment: _commentController.text.trim(),
              images: _images,
            );
      } else {
        final review = Review(
          id: '', // Will be set by notifier
          productId: widget.product.id,
          userId: currentUserId,
          userName: 'You', // In production, get from user profile
          rating: _rating,
          title: _titleController.text.trim(),
          comment: _commentController.text.trim(),
          createdAt: DateTime.now(),
          images: _images,
          isVerifiedPurchase: true, // In production, verify purchase
        );

        ref.read(reviewProvider.notifier).addReview(review);
      }

      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Review updated!' : 'Review submitted!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit review'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          _isEditing ? 'Edit Review' : 'Write a Review',
          style: AppTypography.h4,
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            // Product info
            _buildProductInfo(),
            SizedBox(height: AppSpacing.lg),

            // Rating input
            _buildRatingSection(),
            SizedBox(height: AppSpacing.lg),

            // Title input
            _buildTitleInput(),
            SizedBox(height: AppSpacing.md),

            // Comment input
            _buildCommentInput(),
            SizedBox(height: AppSpacing.md),

            // Image upload
            _buildImageUpload(),
            SizedBox(height: AppSpacing.lg),

            // Guidelines
            _buildGuidelines(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.asset(
              widget.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 60,
                height: 60,
                color: AppColors.backgroundMuted,
                child: Icon(Icons.image, color: AppColors.foregroundMuted),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  widget.product.brand,
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

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overall Rating', style: AppTypography.labelLarge),
        SizedBox(height: AppSpacing.sm),
        Center(
          child: Column(
            children: [
              StarRatingInput(
                rating: _rating,
                onRatingChanged: (rating) {
                  setState(() => _rating = rating);
                  HapticFeedback.selectionClick();
                },
                size: 48,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                _getRatingText(),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRatingText() {
    if (_rating == 0) return 'Tap to rate';
    if (_rating <= 1) return 'Poor';
    if (_rating <= 2) return 'Fair';
    if (_rating <= 3) return 'Good';
    if (_rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Title', style: AppTypography.labelLarge),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Summarize your experience',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            if (value.trim().length < 5) {
              return 'Title must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Review', style: AppTypography.labelLarge),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText:
                'What did you like or dislike? What did you use this product for?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          maxLength: 1000,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your review';
            }
            if (value.trim().length < 20) {
              return 'Review must be at least 20 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add Photos (Optional)', style: AppTypography.labelLarge),
            Text(
              '${_images.length}/5',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add photo button
              if (_images.length < 5)
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 32,
                          color: AppColors.foregroundSecondary,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.foregroundSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Existing images
              ..._images.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md - 1),
                          child: Image.network(
                            entry.value,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColors.backgroundMuted,
                              child: Icon(
                                Icons.image,
                                color: AppColors.foregroundMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(entry.key),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelines() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: AppColors.foregroundSecondary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Review Guidelines',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '• Focus on the product and your experience\n'
            '• Be specific about what you liked or disliked\n'
            '• Keep it respectful and constructive\n'
            '• Don\'t include personal information',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.foregroundSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: PrimaryButton(
          text: _isEditing ? 'Update Review' : 'Submit Review',
          onPressed: _submitReview,
          isLoading: _isSubmitting,
          fullWidth: true,
        ),
      ),
    );
  }
}
