import '../api_client.dart';
import '../api_config.dart';
import '../../../models/product.dart';

/// Product API Service
/// Handles product listing, search, filtering, and details
class ProductService {
  final ApiClient _client;

  ProductService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  // ============ Product Listing ============

  /// Get all products with pagination
  Future<ProductListResponse> getProducts({
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _client.get(
      ApiConfig.products,
      queryParams: {
        'page': page,
        'limit': limit,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      },
      requiresAuth: false,
    );

    return ProductListResponse.fromJson(response.dataAsMap);
  }

  /// Get single product by ID
  Future<Product> getProductById(String productId) async {
    final response = await _client.get(
      ApiConfig.productById(productId),
      requiresAuth: false,
    );
    return Product.fromJson(response.dataAsMap);
  }

  /// Get featured products
  Future<List<Product>> getFeaturedProducts({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.featuredProducts,
      queryParams: {'limit': limit},
      requiresAuth: false,
    );
    return (response.dataAsList).map((json) => Product.fromJson(json)).toList();
  }

  /// Get new arrivals
  Future<List<Product>> getNewArrivals({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.newArrivals,
      queryParams: {'limit': limit},
      requiresAuth: false,
    );
    return (response.dataAsList).map((json) => Product.fromJson(json)).toList();
  }

  /// Get bestsellers
  Future<List<Product>> getBestsellers({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.bestsellers,
      queryParams: {'limit': limit},
      requiresAuth: false,
    );
    return (response.dataAsList).map((json) => Product.fromJson(json)).toList();
  }

  // ============ Categories ============

  /// Get all categories
  Future<List<Category>> getCategories() async {
    final response = await _client.get(
      ApiConfig.categories,
      requiresAuth: false,
    );
    return (response.dataAsList)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  /// Get products by category
  Future<ProductListResponse> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get(
      ApiConfig.productsByCategory(categoryId),
      queryParams: {'page': page, 'limit': limit},
      requiresAuth: false,
    );
    return ProductListResponse.fromJson(response.dataAsMap);
  }

  // ============ Search & Filter ============

  /// Search products
  Future<ProductListResponse> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _client.get(
      ApiConfig.searchProducts,
      queryParams: {
        'q': query,
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category': categoryId,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      },
      requiresAuth: false,
    );
    return ProductListResponse.fromJson(response.dataAsMap);
  }

  /// Get filtered products
  Future<ProductListResponse> getFilteredProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    List<String>? brands,
    double? minRating,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};

    if (categoryId != null) queryParams['category'] = categoryId;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (brands != null && brands.isNotEmpty) {
      queryParams['brands'] = brands.join(',');
    }
    if (minRating != null) queryParams['minRating'] = minRating;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

    final response = await _client.get(
      ApiConfig.products,
      queryParams: queryParams,
      requiresAuth: false,
    );
    return ProductListResponse.fromJson(response.dataAsMap);
  }
}

/// Product list response with pagination
class ProductListResponse {
  final List<Product> products;
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasMore;

  ProductListResponse({
    required this.products,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasMore,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final items = json['items'] ?? json['products'] ?? [];
    final pagination = json['pagination'] ?? json;

    return ProductListResponse(
      products: (items as List).map((p) => Product.fromJson(p)).toList(),
      page: pagination['page'] ?? pagination['currentPage'] ?? 1,
      limit: pagination['limit'] ?? pagination['perPage'] ?? 20,
      totalItems:
          pagination['totalItems'] ?? pagination['total'] ?? items.length,
      totalPages: pagination['totalPages'] ?? pagination['lastPage'] ?? 1,
      hasMore:
          pagination['hasMore'] ??
          (pagination['page'] ?? 1) < (pagination['totalPages'] ?? 1),
    );
  }
}

/// Category model
class Category {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final int productCount;
  final String? parentId;
  final List<Category>? subcategories;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.productCount = 0,
    this.parentId,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image'],
      productCount: json['productCount'] ?? json['count'] ?? 0,
      parentId: json['parentId']?.toString(),
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
                .map((c) => Category.fromJson(c))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'imageUrl': imageUrl,
    'productCount': productCount,
    'parentId': parentId,
  };
}
