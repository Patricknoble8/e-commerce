import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notifiers/product_notifier.dart';
import '../../models/product.dart';

/// Professional filter bottom sheet with shadcn/ui styling
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // Colors
  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);
  static const Color _border = Color(0xFFE4E4E7);
  static const Color _primary = Color(0xFF18181B);

  // Local state for filters
  ProductCategory? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _sortBy = 'popularity';

  final List<String> _sortOptions = [
    'popularity',
    'price_low',
    'price_high',
    'newest',
    'rating',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current filter state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentCategory = ref.read(selectedCategoryProvider);
      final currentPriceRange = ref.read(priceRangeProvider);

      setState(() {
        _selectedCategory = currentCategory;
        if (currentPriceRange != null) {
          _priceRange = RangeValues(currentPriceRange.$1, currentPriceRange.$2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _foreground,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _border),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories section
                  _buildSectionTitle('Category'),
                  const SizedBox(height: 12),
                  _buildCategoryChips(),

                  const SizedBox(height: 24),

                  // Price Range section
                  _buildSectionTitle('Price Range'),
                  const SizedBox(height: 12),
                  _buildPriceRangeSlider(),

                  const SizedBox(height: 24),

                  // Sort By section
                  _buildSectionTitle('Sort By'),
                  const SizedBox(height: 12),
                  _buildSortOptions(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Apply button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _foreground,
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = <ProductCategory?>[
      null, // For "All"
      // Footwear & Clothing
      ProductCategory.footwear,
      ProductCategory.clothing,
      ProductCategory.accessories,
      // Electronics
      ProductCategory.smartphones,
      ProductCategory.laptops,
      ProductCategory.audio,
      ProductCategory.gaming,
      ProductCategory.wearables,
      // Home
      ProductCategory.furniture,
      ProductCategory.kitchen,
      ProductCategory.smartHome,
      // Personal
      ProductCategory.skincare,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category;
        final label = category == null ? 'All' : _getCategoryLabel(category);

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedCategory = category);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _primary : _muted,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? _primary : _border),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : _foreground,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryLabel(ProductCategory category) {
    final labels = {
      ProductCategory.footwear: 'Footwear',
      ProductCategory.clothing: 'Clothing',
      ProductCategory.accessories: 'Accessories',
      ProductCategory.smartphones: 'Phones',
      ProductCategory.laptops: 'Laptops',
      ProductCategory.audio: 'Audio',
      ProductCategory.gaming: 'Gaming',
      ProductCategory.wearables: 'Wearables',
      ProductCategory.furniture: 'Furniture',
      ProductCategory.kitchen: 'Kitchen',
      ProductCategory.smartHome: 'Smart Home',
      ProductCategory.skincare: 'Skincare',
    };
    return labels[category] ?? category.name.capitalize();
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceLabel('\$${_priceRange.start.toInt()}'),
            _buildPriceLabel('\$${_priceRange.end.toInt()}'),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _primary,
            inactiveTrackColor: _muted,
            thumbColor: _primary,
            overlayColor: _primary.withValues(alpha: 0.1),
            trackHeight: 4,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: 2000,
            divisions: 40,
            onChanged: (values) {
              HapticFeedback.selectionClick();
              setState(() => _priceRange = values);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceLabel(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _muted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: Text(
        price,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _foreground,
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    final sortLabels = {
      'popularity': 'Most Popular',
      'price_low': 'Price: Low to High',
      'price_high': 'Price: High to Low',
      'newest': 'Newest First',
      'rating': 'Highest Rated',
    };

    return Column(
      children: _sortOptions.map((option) {
        final isSelected = _sortBy == option;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _sortBy = option);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? _primary.withValues(alpha: 0.05) : _card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primary : _border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sortLabels[option]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _foreground,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: _primary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply Filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCategory = null;
      _priceRange = const RangeValues(0, 1000);
      _sortBy = 'popularity';
    });
  }

  void _applyFilters() {
    HapticFeedback.mediumImpact();

    // Apply category filter
    ref.read(selectedCategoryProvider.notifier).state = _selectedCategory;

    // Apply price range filter
    if (_priceRange.start > 0 || _priceRange.end < 2000) {
      ref.read(priceRangeProvider.notifier).state = (
        _priceRange.start,
        _priceRange.end,
      );
    } else {
      ref.read(priceRangeProvider.notifier).state = null;
    }

    Navigator.pop(context);
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
