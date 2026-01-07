import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/category_data.dart';
import '../../models/category.dart';
import 'category_products_screen.dart';

/// Professional Categories Screen - shadcn/ui inspired design
/// Full category browser with hierarchical navigation
class CategoriesScreen extends StatefulWidget {
  final Category? initialCategory;

  const CategoriesScreen({super.key, this.initialCategory});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // shadcn/ui inspired color palette
  static const Color _background = Color(0xFFFAFAFA);
  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);
  static const Color _border = Color(0xFFE4E4E7);
  static const Color _primary = Color(0xFF18181B);

  Category? _selectedMainCategory;
  Category? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedMainCategory = widget.initialCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: _buildAppBar(),
      body: _selectedMainCategory == null
          ? _buildMainCategories()
          : _buildCategoryDetail(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _card,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: _selectedMainCategory != null
          ? IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  if (_selectedSubCategory != null) {
                    _selectedSubCategory = null;
                  } else {
                    _selectedMainCategory = null;
                  }
                });
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: _foreground,
                size: 20,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: _foreground,
                size: 20,
              ),
            ),
      title: Text(
        _selectedSubCategory?.name ??
            _selectedMainCategory?.name ??
            'All Categories',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _foreground,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _border),
      ),
    );
  }

  Widget _buildMainCategories() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: CategoryData.mainCategories.length,
      itemBuilder: (context, index) {
        final category = CategoryData.mainCategories[index];
        return _buildMainCategoryTile(category);
      },
    );
  }

  Widget _buildMainCategoryTile(Category category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedMainCategory = category;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Emoji container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _muted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      category.emoji ?? '📦',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Category info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _foreground,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (category.hasSubcategories) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${_countSubcategories(category)} subcategories',
                          style: TextStyle(
                            fontSize: 13,
                            color: _mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: _mutedForeground,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _countSubcategories(Category category) {
    int count = category.subcategories.length;
    for (final sub in category.subcategories) {
      count += _countSubcategories(sub);
    }
    return count;
  }

  Widget _buildCategoryDetail() {
    final currentCategory = _selectedSubCategory ?? _selectedMainCategory!;
    final subcategories = currentCategory.subcategories;

    if (subcategories.isEmpty) {
      return _buildEmptyState(currentCategory);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return _buildSubcategoryTile(subcategory);
      },
    );
  }

  Widget _buildSubcategoryTile(Category subcategory) {
    final hasChildren = subcategory.hasSubcategories;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            if (hasChildren) {
              setState(() {
                _selectedSubCategory = subcategory;
              });
            } else {
              // Navigate to products or show coming soon
              _showCategoryProducts(subcategory);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _muted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      hasChildren
                          ? Icons.folder_outlined
                          : Icons.inventory_2_outlined,
                      color: _mutedForeground,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Subcategory info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategory.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _foreground,
                        ),
                      ),
                      if (hasChildren) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${subcategory.subcategories.length} items',
                          style: TextStyle(
                            fontSize: 12,
                            color: _mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow or count badge
                if (hasChildren)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: _mutedForeground,
                    size: 22,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _muted,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Browse',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _mutedForeground,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Category category) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: _muted, shape: BoxShape.circle),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: _mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Products coming soon',
              style: TextStyle(fontSize: 14, color: _mutedForeground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Browse All Products',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryProducts(Category category) {
    // Navigate to category products screen
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(category: category),
      ),
    );
  }
}

/// Compact category chip for home screen display
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);
  static const Color _border = Color(0xFFE4E4E7);
  static const Color _primary = Color(0xFF18181B);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primary : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _primary : _border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.emoji != null) ...[
              Text(category.emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
            ],
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : _foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid item for category display
class CategoryGridItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryGridItem({super.key, required this.category, this.onTap});

  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _border = Color(0xFFE4E4E7);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _muted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  category.emoji ?? '📦',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _foreground,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
