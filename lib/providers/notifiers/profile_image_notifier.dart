import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Profile image state
@immutable
class ProfileImageState {
  final String? imageUrl; // For online images
  final File? localImage; // For local images
  final bool isLoading;
  final String? error;

  const ProfileImageState({
    this.imageUrl,
    this.localImage,
    this.isLoading = false,
    this.error,
  });

  ProfileImageState copyWith({
    String? imageUrl,
    File? localImage,
    bool? isLoading,
    String? error,
    bool clearLocal = false,
    bool clearUrl = false,
  }) {
    return ProfileImageState(
      imageUrl: clearUrl ? null : (imageUrl ?? this.imageUrl),
      localImage: clearLocal ? null : (localImage ?? this.localImage),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Check if there's any image set
  bool get hasImage => imageUrl != null || localImage != null;
}

/// Profile image notifier
class ProfileImageNotifier extends StateNotifier<ProfileImageState> {
  static const double _maxImageWidth = 512;
  static const double _maxImageHeight = 512;
  static const int _imageQuality = 80;
  static const String _defaultAvatarUrl =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200';

  final ImagePicker _picker;

  ProfileImageNotifier({ImagePicker? picker})
    : _picker = picker ?? ImagePicker(),
      super(const ProfileImageState(imageUrl: _defaultAvatarUrl));

  /// Pick image from specified source
  Future<void> _pickImage(ImageSource source, String errorMessage) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: _maxImageWidth,
        maxHeight: _maxImageHeight,
        imageQuality: _imageQuality,
      );

      if (image != null) {
        state = ProfileImageState(
          localImage: File(image.path),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '$errorMessage: $e');
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() =>
      _pickImage(ImageSource.gallery, 'Failed to pick image');

  /// Take photo with camera
  Future<void> takePhoto() =>
      _pickImage(ImageSource.camera, 'Failed to take photo');

  /// Set image from URL
  void setImageUrl(String url) {
    if (url.isEmpty) return;

    state = ProfileImageState(imageUrl: url, isLoading: false);
  }

  /// Remove current image
  void removeImage() {
    state = const ProfileImageState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Profile image provider
final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, ProfileImageState>(
      (ref) => ProfileImageNotifier(),
    );
