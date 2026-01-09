import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../providers/notifiers/profile_image_notifier.dart';

/// Profile image picker with camera, gallery, and URL options
class ProfileImagePicker extends ConsumerWidget {
  final double size;
  final bool editable;

  const ProfileImagePicker({super.key, this.size = 100, this.editable = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(profileImageProvider);

    return Stack(
      children: [
        // Profile image
        GestureDetector(
          onTap: editable ? () => _showImageOptions(context, ref) : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: ClipOval(child: _buildImage(imageState)),
          ),
        ),

        // Edit button
        if (editable)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showImageOptions(context, ref),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: size * 0.18,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        // Loading indicator
        if (imageState.isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage(ProfileImageState state) {
    // Show local image if available
    if (state.localImage != null) {
      return Image.file(
        state.localImage!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stack) => _buildPlaceholder(),
      );
    }

    // Show network image if available
    if (state.imageUrl != null) {
      return Image.network(
        state.imageUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          );
        },
        errorBuilder: (context, error, stack) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.muted,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: AppColors.mutedForeground,
      ),
    );
  }

  void _showImageOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 24),

              // Camera option
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'Take Photo',
                onTap: () {
                  Navigator.pop(context);
                  ref.read(profileImageProvider.notifier).takePhoto();
                },
              ),

              const SizedBox(height: 12),

              // Gallery option
              _buildOption(
                context,
                icon: Icons.photo_library,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(context);
                  ref.read(profileImageProvider.notifier).pickFromGallery();
                },
              ),

              const SizedBox(height: 12),

              // URL option
              _buildOption(
                context,
                icon: Icons.link,
                label: 'Enter Image URL',
                onTap: () {
                  Navigator.pop(context);
                  _showUrlDialog(context, ref);
                },
              ),

              // Remove option (if image exists)
              if (ref.read(profileImageProvider).hasImage) ...[
                const SizedBox(height: 12),
                _buildOption(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Remove Photo',
                  color: AppColors.error,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(profileImageProvider.notifier).removeImage();
                  },
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.primary),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color ?? AppColors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Enter Image URL',
          style: TextStyle(color: AppColors.foreground),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            hintStyle: const TextStyle(color: AppColors.mutedForeground),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: const TextStyle(color: AppColors.foreground),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.foregroundSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(profileImageProvider.notifier)
                    .setImageUrl(controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
