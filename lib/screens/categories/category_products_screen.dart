import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../data/category_data.dart';
import '../../providers/providers.dart';
import '../product_detail/product_detail_screen.dart';

// Shadcn color palette
const _background = Color(0xFFFAFAFA);
const _foreground = Color(0xFF0A0A0A);
const _card = Color(0xFFFFFFFF);
const _cardForeground = Color(0xFF0A0A0A);
const _primary = Color(0xFF18181B);
const _primaryForeground = Color(0xFFFAFAFA);
const _secondary = Color(0xFFF4F4F5);
const _secondaryForeground = Color(0xFF18181B);
const _muted = Color(0xFFF4F4F5);
const _mutedForeground = Color(0xFF71717A);
const _border = Color(0xFFE4E4E7);
const _destructive = Color(0xFFEF4444);

enum SortOption { featured, priceLowToHigh, priceHighToLow, newest, topRated }

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  SortOption _selectedSort = SortOption.featured;
  String? _selectedSubcategoryId;
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productListProvider);
    final filteredProducts = _getFilteredProducts(allProducts);

    return Scaffold(
      backgroundColor: _background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: _card,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: _foreground,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showSortBottomSheet();
                },
                icon: const Icon(Icons.sort_rounded, size: 22),
                color: _foreground,
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _showFilters = !_showFilters);
                },
                icon: Icon(
                  _showFilters
                      ? Icons.filter_list_off_rounded
                      : Icons.filter_list_rounded,
                  size: 22,
                ),
                color: _showFilters ? _destructive : _foreground,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 56,
                bottom: 16,
                right: 56,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.category.emoji ?? '📦',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.category.name,
                          style: const TextStyle(
                            color: _foreground,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${filteredProducts.length} products',
                    style: const TextStyle(
                      color: _mutedForeground,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            bottom: widget.category.hasSubcategories
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: _buildSubcategoryChips(),
                  )
                : null,
          ),

          // Filter Panel
          if (_showFilters) SliverToBoxAdapter(child: _buildFilterPanel()),

          // Products Grid
          if (filteredProducts.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildProductCard(filteredProducts[index]),
                  childCount: filteredProducts.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    var products = allProducts.where((product) {
      // Filter by category
      if (widget.category.isMainCategory) {
        // For main categories, match by categoryId or by product category name
        if (product.categoryId != null) {
          return product.categoryId == widget.category.id ||
              _isSubcategoryOf(product.categoryId!, widget.category.id);
        }
        // Fallback: match by enum category name
        return _matchesCategoryByName(product, widget.category);
      } else {
        // For subcategories
        if (product.subcategoryId != null) {
          return product.subcategoryId == widget.category.id;
        }
        if (product.categoryId != null) {
          return product.categoryId == widget.category.id;
        }
        return _matchesCategoryByName(product, widget.category);
      }
    }).toList();

    // Filter by selected subcategory
    if (_selectedSubcategoryId != null) {
      products = products.where((product) {
        return product.subcategoryId == _selectedSubcategoryId ||
            product.categoryId == _selectedSubcategoryId;
      }).toList();
    }

    // Filter by price range
    products = products.where((product) {
      return product.finalPrice >= _priceRange.start &&
          product.finalPrice <= _priceRange.end;
    }).toList();

    // Sort products
    switch (_selectedSort) {
      case SortOption.priceLowToHigh:
        products.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case SortOption.priceHighToLow:
        products.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case SortOption.topRated:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.newest:
        // For demo, reverse order to simulate newest
        products = products.reversed.toList();
        break;
      case SortOption.featured:
        // Keep original order
        break;
    }

    return products;
  }

  bool _isSubcategoryOf(String categoryId, String parentId) {
    final category = CategoryData.findById(categoryId);
    if (category == null) return false;
    return category.parentId == parentId;
  }

  bool _matchesCategoryByName(Product product, Category category) {
    final productCategoryName = product.category
        .toString()
        .split('.')
        .last
        .toLowerCase();
    final categoryId = category.id.toLowerCase();
    final categoryName = category.name.toLowerCase();

    // Direct mapping from ProductCategory enum to main categories
    final categoryMappings = <String, List<String>>{
      // Fashion category mappings
      'fashion': [
        'menswear',
        'womenswear',
        'kidswear',
        'tshirts',
        'shirts',
        'pants',
        'jeans',
        'dresses',
        'jackets',
        'coats',
        'sweaters',
        'hoodies',
        'shorts',
        'skirts',
        'suits',
        'activewear',
        'underwear',
        'sleepwear',
      ],
      'mens': ['menswear', 'tshirts', 'shirts', 'pants', 'jeans', 'suits'],
      'womens': ['womenswear', 'dresses', 'skirts', 'blouses'],
      'kids': ['kidswear'],

      // Footwear category mappings
      'footwear': [
        'sneakers',
        'running',
        'basketball',
        'lifestyle',
        'casual',
        'boots',
        'sandals',
        'heels',
        'flats',
        'loafers',
        'athletic',
      ],
      'sneakers': [
        'sneakers',
        'running',
        'basketball',
        'lifestyle',
        'casual',
        'athletic',
      ],
      'running': ['running', 'athletic'],
      'basketball': ['basketball'],
      'boots': ['boots'],
      'sandals': ['sandals'],

      // Accessories mappings
      'accessories': [
        'bags',
        'watches',
        'jewelry',
        'sunglasses',
        'hats',
        'belts',
        'scarves',
        'wallets',
        'backpacks',
        'handbags',
      ],
      'bags': ['bags', 'backpacks', 'handbags', 'wallets'],
      'watches': ['watches', 'smartwatches'],

      // Electronics mappings
      'electronics': [
        'phones',
        'laptops',
        'tablets',
        'audio',
        'gaming',
        'cameras',
        'tvs',
        'wearables',
        'accessories',
        'headphones',
        'speakers',
      ],
      'phones': ['phones', 'smartphones', 'mobile'],
      'laptops': ['laptops', 'computers'],
      'audio': ['audio', 'headphones', 'speakers', 'earbuds'],
      'gaming': ['gaming', 'playstation', 'xbox', 'nintendo'],

      // Home & Living mappings
      'home': [
        'furniture',
        'decor',
        'kitchen',
        'bedding',
        'bath',
        'lighting',
        'storage',
        'rugs',
        'curtains',
        'appliances',
      ],
      'kitchen': ['kitchen', 'cookware', 'appliances'],
      'furniture': ['furniture', 'chairs', 'tables', 'sofas', 'beds'],

      // Beauty mappings
      'beauty': [
        'skincare',
        'makeup',
        'haircare',
        'fragrance',
        'bodycare',
        'cosmetics',
        'perfume',
        'nails',
      ],
      'skincare': ['skincare', 'moisturizer', 'serum', 'cleanser'],
      'makeup': ['makeup', 'cosmetics', 'lipstick', 'foundation'],

      // Health mappings
      'health': [
        'vitamins',
        'supplements',
        'fitness',
        'wellness',
        'personal care',
        'medical',
        'firstaid',
      ],
      'fitness': ['fitness', 'gym', 'workout', 'exercise'],

      // Sports mappings
      'sports': [
        'running',
        'basketball',
        'football',
        'soccer',
        'tennis',
        'golf',
        'swimming',
        'cycling',
        'yoga',
        'outdoor',
        'camping',
        'hiking',
        'athletic',
        'sportswear',
        'activewear',
        'fitness',
      ],
      'outdoor': ['outdoor', 'camping', 'hiking'],

      // Toys mappings
      'toys': [
        'toys',
        'games',
        'puzzles',
        'dolls',
        'action figures',
        'educational',
      ],

      // Books mappings
      'books': ['books', 'fiction', 'nonfiction', 'textbooks', 'magazines'],

      // Baby mappings
      'baby': ['baby', 'infant', 'toddler', 'nursery', 'diapers', 'feeding'],

      // Automotive mappings
      'automotive': [
        'car',
        'auto',
        'motorcycle',
        'parts',
        'accessories',
        'tools',
      ],

      // Pet mappings
      'pet': ['pet', 'dog', 'cat', 'fish', 'bird', 'petfood', 'petsupplies'],

      // Grocery mappings
      'grocery': ['food', 'beverages', 'snacks', 'organic', 'pantry', 'frozen'],

      // Office mappings
      'office': ['office', 'stationery', 'desk', 'supplies', 'printer'],

      // Garden mappings
      'garden': ['garden', 'plants', 'outdoor furniture', 'tools', 'patio'],

      // Jewelry mappings
      'jewelry': [
        'jewelry',
        'rings',
        'necklaces',
        'bracelets',
        'earrings',
        'watches',
      ],

      // Tools mappings
      'tools': ['tools', 'power tools', 'hand tools', 'hardware'],
    };

    // Check if product category matches the current category
    for (final entry in categoryMappings.entries) {
      if (categoryId.contains(entry.key) || categoryName.contains(entry.key)) {
        if (entry.value.any(
          (keyword) =>
              productCategoryName.contains(keyword) ||
              keyword.contains(productCategoryName),
        )) {
          return true;
        }
      }
    }

    // Direct name matching as fallback
    return productCategoryName.contains(categoryId) ||
        categoryId.contains(productCategoryName) ||
        productCategoryName.contains(
          categoryName.replaceAll(' ', '').replaceAll('&', ''),
        ) ||
        categoryName
            .replaceAll(' ', '')
            .replaceAll('&', '')
            .contains(productCategoryName);
  }

  Widget _buildSubcategoryChips() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: _card,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildChip('All', null),
          ...widget.category.subcategories.map(
            (sub) => _buildChip(sub.name, sub.id),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String? subcategoryId) {
    final isSelected = _selectedSubcategoryId == subcategoryId;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedSubcategoryId = selected ? subcategoryId : null;
          });
        },
        backgroundColor: _secondary,
        selectedColor: _primary,
        labelStyle: TextStyle(
          color: isSelected ? _primaryForeground : _secondaryForeground,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        checkmarkColor: _primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? _primary : _border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: _card,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Range',
            style: TextStyle(
              color: _foreground,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: const TextStyle(color: _mutedForeground, fontSize: 13),
              ),
              Expanded(
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  activeColor: _primary,
                  inactiveColor: _muted,
                  onChanged: (values) {
                    setState(() => _priceRange = values);
                  },
                ),
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: const TextStyle(color: _mutedForeground, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _priceRange = const RangeValues(0, 1000);
                    _selectedSubcategoryId = null;
                    _selectedSort = SortOption.featured;
                  });
                },
                child: const Text(
                  'Reset Filters',
                  style: TextStyle(
                    color: _destructive,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort By',
              style: TextStyle(
                color: _foreground,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption(
              'Featured',
              SortOption.featured,
              Icons.star_rounded,
            ),
            _buildSortOption(
              'Price: Low to High',
              SortOption.priceLowToHigh,
              Icons.arrow_upward_rounded,
            ),
            _buildSortOption(
              'Price: High to Low',
              SortOption.priceHighToLow,
              Icons.arrow_downward_rounded,
            ),
            _buildSortOption(
              'Top Rated',
              SortOption.topRated,
              Icons.thumb_up_rounded,
            ),
            _buildSortOption(
              'Newest',
              SortOption.newest,
              Icons.new_releases_rounded,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, SortOption option, IconData icon) {
    final isSelected = _selectedSort == option;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? _primary : _mutedForeground,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? _primary : _foreground,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: _primary, size: 22)
          : null,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedSort = option);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _muted,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: _mutedForeground,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No products found',
            style: TextStyle(
              color: _foreground,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters\nor check back later',
            textAlign: TextAlign.center,
            style: TextStyle(color: _mutedForeground, fontSize: 14),
          ),
          const SizedBox(height: 24),
          if (_showFilters || _selectedSubcategoryId != null)
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _priceRange = const RangeValues(0, 1000);
                  _selectedSubcategoryId = null;
                  _selectedSort = SortOption.featured;
                  _showFilters = false;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Filters'),
              style: TextButton.styleFrom(foregroundColor: _primary),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: _buildNetworkImage(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _destructive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discount!.round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Add to Cart Button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Material(
                      color: _primary,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          // Add to cart with default color and size
                          ref
                              .read(cartProvider.notifier)
                              .addToCart(
                                product,
                                product.availableColors.isNotEmpty
                                    ? product.availableColors.first
                                    : 'Default',
                                product.availableSizes.isNotEmpty
                                    ? product.availableSizes.first
                                    : 42,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: _primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add_rounded,
                            color: _primaryForeground,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    if (product.brand.isNotEmpty)
                      Text(
                        product.brand.toUpperCase(),
                        style: const TextStyle(
                          color: _mutedForeground,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    // Name
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          color: _cardForeground,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFBBF24),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: _foreground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (product.reviewCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount})',
                            style: const TextStyle(
                              color: _mutedForeground,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${product.finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: _foreground,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: _mutedForeground,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url, {double? width, double? height}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: _muted,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _mutedForeground,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: _muted,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: _mutedForeground,
          size: 32,
        ),
      ),
    );
  }
}
