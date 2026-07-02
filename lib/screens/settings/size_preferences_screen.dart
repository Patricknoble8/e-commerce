import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/common/app_back_button.dart';

/// Provider for size preferences
final sizePreferencesProvider =
    StateNotifierProvider<SizePreferencesNotifier, SizePreferences>((ref) {
      return SizePreferencesNotifier();
    });

class SizePreferences {
  final String? shoeSize;
  final String? clothingSize;
  final String? pantSize;
  final String? shirtSize;
  final bool useMetric;

  const SizePreferences({
    this.shoeSize,
    this.clothingSize,
    this.pantSize,
    this.shirtSize,
    this.useMetric = false,
  });

  SizePreferences copyWith({
    String? shoeSize,
    String? clothingSize,
    String? pantSize,
    String? shirtSize,
    bool? useMetric,
  }) {
    return SizePreferences(
      shoeSize: shoeSize ?? this.shoeSize,
      clothingSize: clothingSize ?? this.clothingSize,
      pantSize: pantSize ?? this.pantSize,
      shirtSize: shirtSize ?? this.shirtSize,
      useMetric: useMetric ?? this.useMetric,
    );
  }
}

class SizePreferencesNotifier extends StateNotifier<SizePreferences> {
  SizePreferencesNotifier() : super(const SizePreferences());

  void setShoeSize(String size) {
    state = state.copyWith(shoeSize: size);
  }

  void setClothingSize(String size) {
    state = state.copyWith(clothingSize: size);
  }

  void setPantSize(String size) {
    state = state.copyWith(pantSize: size);
  }

  void setShirtSize(String size) {
    state = state.copyWith(shirtSize: size);
  }

  void setUseMetric(bool value) {
    state = state.copyWith(useMetric: value);
  }

  void reset() {
    state = const SizePreferences();
  }
}

/// Size preferences screen for managing default sizes
class SizePreferencesScreen extends ConsumerWidget {
  const SizePreferencesScreen({super.key});

  static const List<String> _usShoesMen = [
    '6',
    '6.5',
    '7',
    '7.5',
    '8',
    '8.5',
    '9',
    '9.5',
    '10',
    '10.5',
    '11',
    '11.5',
    '12',
    '13',
    '14',
  ];

  static const List<String> _euShoes = [
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
  ];

  static const List<String> _clothingSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '3XL',
  ];

  static const List<String> _pantSizes = [
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '36',
    '38',
    '40',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppColors.bind(context);
    final prefs = ref.watch(sizePreferencesProvider);
    final notifier = ref.read(sizePreferencesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Size Preferences',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notifier.reset();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Preferences reset'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              'Reset',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Save your sizes for faster checkout and personalized recommendations',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Unit preference
            _buildSectionHeader('Measurement System'),
            SizedBox(height: AppSpacing.sm),
            _buildUnitToggle(context, ref, prefs.useMetric),
            SizedBox(height: AppSpacing.xl),

            // Shoe size
            _buildSectionHeader('Shoe Size'),
            SizedBox(height: AppSpacing.sm),
            _buildSizeSelector(
              context: context,
              sizes: prefs.useMetric ? _euShoes : _usShoesMen,
              selectedSize: prefs.shoeSize,
              onSelect: (size) {
                notifier.setShoeSize(size);
                HapticFeedback.selectionClick();
              },
            ),
            SizedBox(height: AppSpacing.xl),

            // Clothing size
            _buildSectionHeader('Clothing Size (Tops)'),
            SizedBox(height: AppSpacing.sm),
            _buildSizeSelector(
              context: context,
              sizes: _clothingSizes,
              selectedSize: prefs.clothingSize,
              onSelect: (size) {
                notifier.setClothingSize(size);
                HapticFeedback.selectionClick();
              },
            ),
            SizedBox(height: AppSpacing.xl),

            // Pant size
            _buildSectionHeader('Pant Size (Waist)'),
            SizedBox(height: AppSpacing.sm),
            _buildSizeSelector(
              context: context,
              sizes: _pantSizes,
              selectedSize: prefs.pantSize,
              onSelect: (size) {
                notifier.setPantSize(size);
                HapticFeedback.selectionClick();
              },
            ),
            SizedBox(height: AppSpacing.xl),

            // Size guide link
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _showSizeGuideDialog(context);
                },
                icon: const Icon(Icons.straighten, size: 18),
                label: const Text('View Size Guide'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            text: 'Save Preferences',
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Size preferences saved!'),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.labelLarge.copyWith(
        color: AppColors.foreground,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUnitToggle(BuildContext context, WidgetRef ref, bool useMetric) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(sizePreferencesProvider.notifier).setUseMetric(false);
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: !useMetric ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(AppRadius.md - 1),
                  ),
                ),
                child: Text(
                  'US / UK',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    color: !useMetric
                        ? AppColors.primaryForeground
                        : AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(sizePreferencesProvider.notifier).setUseMetric(true);
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: useMetric ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(AppRadius.md - 1),
                  ),
                ),
                child: Text(
                  'EU / Metric',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    color: useMetric
                        ? AppColors.primaryForeground
                        : AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector({
    required BuildContext context,
    required List<String> sizes,
    required String? selectedSize,
    required Function(String) onSelect,
  }) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: sizes.map((size) {
        final isSelected = selectedSize == size;
        return GestureDetector(
          onTap: () => onSelect(size),
          child: Container(
            constraints: const BoxConstraints(minWidth: 52),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              size,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.primaryForeground
                    : AppColors.foreground,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showSizeGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Size Guide',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSizeGuideRow('US 6', 'EU 38', '24 cm'),
              _buildSizeGuideRow('US 7', 'EU 39', '25 cm'),
              _buildSizeGuideRow('US 8', 'EU 40', '26 cm'),
              _buildSizeGuideRow('US 9', 'EU 41', '27 cm'),
              _buildSizeGuideRow('US 10', 'EU 42', '28 cm'),
              _buildSizeGuideRow('US 11', 'EU 43', '29 cm'),
              _buildSizeGuideRow('US 12', 'EU 44', '30 cm'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeGuideRow(String us, String eu, String cm) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(us, style: AppTypography.bodySmall),
          Text(eu, style: AppTypography.bodySmall),
          Text(cm, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
