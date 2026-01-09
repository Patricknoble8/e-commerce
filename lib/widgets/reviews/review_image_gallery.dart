import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';

/// Full-screen image gallery for reviews
class ReviewImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ReviewImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ReviewImageGallery> createState() => _ReviewImageGalleryState();
}

class _ReviewImageGalleryState extends State<ReviewImageGallery> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dismiss on tap background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // Image viewer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _resetZoom();
              HapticFeedback.selectionClick();
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  transformationController: index == _currentIndex
                      ? _transformationController
                      : null,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.white54,
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            right: AppSpacing.md,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),

          // Page indicator
          if (widget.images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Thumbnail strip
          if (widget.images.length > 1)
            Positioned(
              bottom:
                  MediaQuery.of(context).padding.bottom + AppSpacing.xl + 50,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: widget.images.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final isSelected = index == _currentIndex;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.white30,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppRadius.sm - 1,
                            ),
                            child: Opacity(
                              opacity: isSelected ? 1.0 : 0.6,
                              child: Image.network(
                                widget.images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[800],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white30,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Zoomable image widget for product detail
class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final BoxFit fit;

  const ZoomableImage({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.fit = BoxFit.contain,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap(TapDownDetails details) {
    if (_controller.value != Matrix4.identity()) {
      // Zoom out
      _animation =
          Matrix4Tween(
            begin: _controller.value,
            end: Matrix4.identity(),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
          );
      _animationController.forward(from: 0);
    } else {
      // Zoom in
      final position = details.localPosition;
      final zoomed = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.5)
        ..translate(position.dx, position.dy);

      _animation = Matrix4Tween(begin: _controller.value, end: zoomed).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
    }

    _animationController.addListener(() {
      _controller.value = _animation!.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = InteractiveViewer(
      transformationController: _controller,
      minScale: 0.5,
      maxScale: 4.0,
      child: GestureDetector(
        onDoubleTapDown: _onDoubleTap,
        child: Image.network(
          widget.imageUrl,
          fit: widget.fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.backgroundMuted,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: AppColors.foregroundMuted,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: imageWidget);
    }

    return imageWidget;
  }
}
