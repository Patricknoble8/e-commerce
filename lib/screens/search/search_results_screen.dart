import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notifiers/product_notifier.dart';
import '../../models/product.dart';
import '../../widgets/common/cached_image.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/app_back_button.dart';
import '../product_detail/product_detail_screen.dart';

/// Professional search results screen with real-time filtering
class SearchResultsScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchResultsScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  Timer? _searchDebounce;
  bool _isLoading = false;

  // Colors
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
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    // Set initial search query
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchQueryProvider.notifier).state = widget.initialQuery!;
      });
    }

    // Auto focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _isLoading = true);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        ref.read(searchQueryProvider.notifier).state = value.trim();
        setState(() => _isLoading = false);
      }
    });
  }

  void _clearSearch() {
    HapticFeedback.lightImpact();
    _searchDebounce?.cancel();
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() => _isLoading = false);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: _background,
      appBar: _buildSearchAppBar(),
      body: Column(
        children: [
          // Search info
          if (searchQuery.isNotEmpty)
            _buildSearchInfo(products.length, searchQuery),

          // Results
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : products.isEmpty
                ? _buildEmptyState(searchQuery)
                : _buildResultsList(products, favorites),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: _background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: AppBackButton(
        foregroundColor: _foreground,
        backgroundColor: _background,
        onPressed: () {
          // Clear search when leaving
          ref.read(searchQueryProvider.notifier).state = '';
          Navigator.of(context).maybePop();
        },
      ),
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, color: _mutedForeground, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: _mutedForeground, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(color: _foreground, fontSize: 14),
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.close, color: _mutedForeground, size: 20),
                onPressed: _clearSearch,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInfo(int count, String query) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            '$count results for ',
            style: TextStyle(fontSize: 14, color: _mutedForeground),
          ),
          Text(
            '"$query"',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const ListItemShimmer(),
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: _muted, shape: BoxShape.circle),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: _mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              query.isEmpty ? 'Start searching' : 'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              query.isEmpty
                  ? 'Search for products by name, brand, or category'
                  : 'Try different keywords or check spelling',
              style: TextStyle(fontSize: 14, color: _mutedForeground),
              textAlign: TextAlign.center,
            ),
            if (query.isNotEmpty) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: _clearSearch,
                icon: Icon(Icons.refresh, color: _primary),
                label: Text(
                  'Clear search',
                  style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<Product> products, Set<String> favorites) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(product.id);
        return _buildProductListItem(product, isFavorite);
      },
    );
  }

  Widget _buildProductListItem(Product product, bool isFavorite) {
    return Semantics(
      label:
          '${product.name} by ${product.brand}, price ${product.finalPrice.toStringAsFixed(0)} dollars',
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: OptimizedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Product info
              Expanded(
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
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _foreground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.finalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _foreground,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _mutedForeground,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _destructive.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${product.discount!.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _destructive,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(product.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? _destructive.withValues(alpha: 0.1)
                        : _muted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? _destructive : _mutedForeground,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
