import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../providers/notifiers/notifications_notifier.dart';
import '../../models/product.dart';
import '../../data/category_data.dart';
import '../product_detail/product_detail_screen.dart';
import '../notifications/notifications_screen.dart';
import '../categories/categories_screen.dart';
import '../search/search_results_screen.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/filter_bottom_sheet.dart';

/// Professional E-Commerce Home Screen
/// shadcn/ui inspired design - Clean, minimal, elegant
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _heroController = PageController();
  final TextEditingController _searchController = TextEditingController();
  int _currentHeroPage = 0;
  Timer? _heroTimer;
  String _selectedFilter = 'All';
  int _selectedNavIndex = 0;
  late AnimationController _fadeController;

  // shadcn/ui inspired color palette
  static const Color _background = Color(0xFFFAFAFA);
  static const Color _foreground = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFF4F4F5);
  static const Color _mutedForeground = Color(0xFF71717A);
  static const Color _border = Color(0xFFE4E4E7);
  static const Color _primary = Color(0xFF18181B);
  static const Color _destructive = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeController.forward();
    _startHeroAutoScroll();
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroTimer = null;
    _heroController.dispose();
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_heroController.hasClients) {
        final nextPage = (_currentHeroPage + 1) % 3;
        _heroController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _background,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            ref.invalidate(filteredProductsProvider);
            await Future.delayed(const Duration(milliseconds: 800));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Products refreshed!'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _primary,
                  duration: const Duration(seconds: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          color: _primary,
          backgroundColor: _card,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(unreadCount),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildHeroCarousel(),
                    const SizedBox(height: 32),
                    _buildCategorySection(),
                    const SizedBox(height: 32),
                    _buildBestSellersSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ============ NETWORK IMAGE WITH LOADING ============
  Widget _buildNetworkImage(
    String url, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: child,
          );
        }
        return Container(
          width: width,
          height: height,
          color: _muted,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _mutedForeground,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: _muted,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: _mutedForeground,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              'Image unavailable',
              style: TextStyle(fontSize: 10, color: _mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  // ============ SHIMMER/SKELETON PLACEHOLDER ============
  Widget _buildShimmer({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 0.7),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: _muted.withOpacity(value),
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }

  Widget _buildProductCardShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: _muted,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmer(width: 50, height: 10),
                  const SizedBox(height: 8),
                  _buildShimmer(width: double.infinity, height: 14),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmer(width: 60, height: 16),
                      _buildShimmer(width: 32, height: 32, radius: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ APP BAR - Clean & Minimal ============
  Widget _buildAppBar(int unreadCount) {
    return SliverAppBar(
      floating: true,
      backgroundColor: _background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 60,
      leading: Container(
        margin: const EdgeInsets.only(left: 16),
        child: Semantics(
          label: 'Open menu',
          button: true,
          child: IconButton(
            icon: Icon(Icons.menu_rounded, color: _foreground, size: 24),
            onPressed: () {
              HapticFeedback.lightImpact();
              _scaffoldKey.currentState?.openDrawer();
            },
            style: IconButton.styleFrom(
              backgroundColor: _card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: _border),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: _primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            'Luxe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _foreground,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: _foreground,
                  size: 24,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: _card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: _border),
                  ),
                ),
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 14,
                top: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: _background, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ============ SEARCH BAR - shadcn/ui Input Style ============
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 52,
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
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search_rounded, color: _mutedForeground, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: _mutedForeground,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(color: _foreground, fontSize: 14),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchResultsScreen(initialQuery: value.trim()),
                      ),
                    );
                  }
                },
              ),
            ),
            Semantics(
              label: 'Open filters',
              button: true,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) =>
                          const FilterBottomSheet(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ HERO CAROUSEL - Premium Cards ============
  Widget _buildHeroCarousel() {
    final heroSlides = [
      {
        'title': 'NEW ARRIVALS',
        'discount': '20% OFF',
        'subtitle': 'Discover Happiness',
        'cta': 'Shop Now',
        'image':
            'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&h=400&fit=crop',
      },
      {
        'title': 'SUMMER COLLECTION',
        'discount': '30% OFF',
        'subtitle': 'Elegant Designs',
        'cta': 'Explore',
        'image':
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&h=400&fit=crop',
      },
      {
        'title': 'PREMIUM DIAMONDS',
        'discount': '15% OFF',
        'subtitle': 'Timeless Beauty',
        'cta': 'View Collection',
        'image':
            'https://images.unsplash.com/photo-1602173574767-37ac01994b2a?w=600&h=400&fit=crop',
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _heroController,
            onPageChanged: (index) => setState(() => _currentHeroPage = index),
            itemCount: heroSlides.length,
            itemBuilder: (context, index) {
              final slide = heroSlides[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to promotion
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildNetworkImage(
                          slide['image'] as String,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.75),
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  slide['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                slide['discount'] as String,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                slide['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slide['cta'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _foreground,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                      color: _foreground,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Minimal dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            heroSlides.length,
            (index) => GestureDetector(
              onTap: () {
                _heroController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentHeroPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentHeroPage == index ? _primary : _border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============ CATEGORY SECTION - Professional shadcn/ui Grid ============
  Widget _buildCategorySection() {
    // Show first 8 main categories on home screen
    final displayCategories = CategoryData.mainCategories.take(8).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _foreground,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: _mutedForeground,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Horizontal scrolling category chips with emoji
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = displayCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(category) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(initialCategory: category),
          ),
        );
      },
      child: SizedBox(
        width: 85,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  category.emoji ?? '📦',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.name.split(' ').first, // Show first word only
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _foreground,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ============ BEST SELLERS SECTION ============
  Widget _buildBestSellersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Sellers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _foreground,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 20),
          _buildProductGrid(),
        ],
      ),
    );
  }

  // ============ FILTER CHIPS - shadcn/ui Tabs Style ============
  Widget _buildFilterChips() {
    final filters = ['All', 'Newest', 'Popular', 'Trendy', 'Best'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _muted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedFilter = filter);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _card : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? _foreground : _mutedForeground,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============ PRODUCT GRID - shadcn/ui Card Style ============
  Widget _buildProductGrid() {
    final products = ref.watch(filteredProductsProvider);
    final favorites = ref.watch(favoritesProvider);

    // Show shimmer loading when products are empty
    if (products.isEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => _buildProductCardShimmer(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length > 6 ? 6 : products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(product.id);
        return _buildProductCard(product, isFavorite);
      },
    );
  }

  Widget _buildProductCard(Product product, bool isFavorite) {
    return Semantics(
      label:
          '${product.name} by ${product.brand}, price \$${product.finalPrice.toStringAsFixed(0)}${product.hasDiscount ? ', ${product.discount!.toStringAsFixed(0)}% off' : ''}',
      button: true,
      child: GestureDetector(
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with favorite button
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(11),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildNetworkImage(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Semantics(
                        label: isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(favoritesProvider.notifier)
                                .toggleFavorite(product.id);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isFavorite
                                  ? _destructive.withOpacity(0.1)
                                  : _card,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? _destructive
                                  : _mutedForeground,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Discount badge
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
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${product.discount!.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Product info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _mutedForeground,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _foreground,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${product.finalPrice.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _foreground,
                                  ),
                                ),
                                if (product.hasDiscount)
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: _mutedForeground,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Semantics(
                            label: 'Add ${product.name} to cart',
                            button: true,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                // Handle size safely - can be int or String
                                final firstSize =
                                    product.availableSizes.isNotEmpty
                                    ? (product.availableSizes.first is int
                                          ? product.availableSizes.first as int
                                          : int.tryParse(
                                                  product.availableSizes.first
                                                      .toString(),
                                                ) ??
                                                0)
                                    : 0;
                                ref
                                    .read(cartProvider.notifier)
                                    .addToCart(
                                      product,
                                      product.availableColors.isNotEmpty
                                          ? product.availableColors.first
                                          : 'Default',
                                      firstSize,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: const [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Text('Added to cart'),
                                      ],
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: _primary,
                                    duration: const Duration(seconds: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                    action: SnackBarAction(
                                      label: 'View',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/cart');
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ BOTTOM NAV BAR - shadcn/ui Style ============
  Widget _buildBottomNavBar() {
    final cartItemCount = ref.watch(cartProvider).itemCount;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItemWithBadge(
                Icons.shopping_bag_outlined,
                'Cart',
                1,
                cartItemCount,
              ),
              _buildNavItem(Icons.favorite_outline, 'Wishlist', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedNavIndex = index);
        if (label == 'Cart') {
          Navigator.pushNamed(context, '/cart');
        } else if (label == 'Wishlist') {
          Navigator.pushNamed(context, '/wishlist');
        } else if (label == 'Profile') {
          Navigator.pushNamed(context, '/profile');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _muted : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? _getActiveIcon(icon) : icon,
              color: isActive ? _foreground : _mutedForeground,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? _foreground : _mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge(
    IconData icon,
    String label,
    int index,
    int badgeCount,
  ) {
    final isActive = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedNavIndex = index);
        Navigator.pushNamed(context, '/cart');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _muted : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? Icons.shopping_bag : icon,
                  color: isActive ? _foreground : _mutedForeground,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(color: _card, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badgeCount > 9 ? '9+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? _foreground : _mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActiveIcon(IconData icon) {
    if (icon == Icons.home_rounded) return Icons.home_rounded;
    if (icon == Icons.shopping_bag_outlined) return Icons.shopping_bag;
    if (icon == Icons.favorite_outline) return Icons.favorite;
    if (icon == Icons.person_outline) return Icons.person;
    return icon;
  }
}
