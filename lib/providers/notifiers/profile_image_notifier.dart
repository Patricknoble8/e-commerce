import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

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

/// Profile image notifier with persistence
class ProfileImageNotifier extends StateNotifier<ProfileImageState> {
  static const double _maxImageWidth = 512;
  static const double _maxImageHeight = 512;
  static const int _imageQuality = 80;
  static const String _defaultAvatarUrl =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200';
  static const String _prefsKeyLocalPath = 'profile_image_local_path';
  static const String _prefsKeyImageUrl = 'profile_image_url';

  final ImagePicker _picker;

  ProfileImageNotifier({ImagePicker? picker})
    : _picker = picker ?? ImagePicker(),
      super(const ProfileImageState(isLoading: true)) {
    _loadSavedImage();
  }

  /// Load saved image from storage
  Future<void> _loadSavedImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString(_prefsKeyLocalPath);
      final savedUrl = prefs.getString(_prefsKeyImageUrl);

      if (localPath != null && await File(localPath).exists()) {
        state = ProfileImageState(
          localImage: File(localPath),
          isLoading: false,
        );
      } else if (savedUrl != null && savedUrl.isNotEmpty) {
        state = ProfileImageState(imageUrl: savedUrl, isLoading: false);
      } else {
        state = const ProfileImageState(
          imageUrl: _defaultAvatarUrl,
          isLoading: false,
        );
      }
    } catch (e) {
      state = const ProfileImageState(
        imageUrl: _defaultAvatarUrl,
        isLoading: false,
      );
    }
  }

  /// Save image path to persistent storage
  Future<void> _saveImagePath(String? localPath, String? url) async {
    final prefs = await SharedPreferences.getInstance();
    if (localPath != null) {
      await prefs.setString(_prefsKeyLocalPath, localPath);
      await prefs.remove(_prefsKeyImageUrl);
    } else if (url != null) {
      await prefs.setString(_prefsKeyImageUrl, url);
      await prefs.remove(_prefsKeyLocalPath);
    } else {
      await prefs.remove(_prefsKeyLocalPath);
      await prefs.remove(_prefsKeyImageUrl);
    }
  }

  /// Copy image to app directory for persistence
  Future<File> _copyToAppDirectory(File sourceFile) async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final profileImagesDir = Directory('${appDir.path}/profile_images');
    if (!await profileImagesDir.exists()) {
      await profileImagesDir.create(recursive: true);
    }

    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourceFile.path)}';
    final destPath = '${profileImagesDir.path}/$fileName';

    return await sourceFile.copy(destPath);
  }

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
        // Copy to app directory for persistence
        final savedFile = await _copyToAppDirectory(File(image.path));
        await _saveImagePath(savedFile.path, null);

        state = ProfileImageState(localImage: savedFile, isLoading: false);
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
  Future<void> setImageUrl(String url) async {
    if (url.isEmpty) return;

    await _saveImagePath(null, url);
    state = ProfileImageState(imageUrl: url, isLoading: false);
  }

  /// Remove current image
  Future<void> removeImage() async {
    // Delete old local file if exists
    if (state.localImage != null && await state.localImage!.exists()) {
      try {
        await state.localImage!.delete();
      } catch (e) {
        // Ignore deletion errors
      }
    }

    await _saveImagePath(null, null);
    state = const ProfileImageState(
      imageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    );
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
