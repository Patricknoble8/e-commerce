import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/product.dart';

/// Paginated response for products
class ProductsResponse {
  final List<Product> products;
  final int total;
  final int page;
  final int perPage;
  final bool hasMore;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.page,
    required this.perPage,
    required this.hasMore,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final productsList = (json['products'] ?? json['data'] ?? []) as List;
    final meta = json['meta'] ?? json;

    return ProductsResponse(
      products: productsList.map((e) => Product.fromJson(e)).toList(),
      total: meta['total'] ?? productsList.length,
      page: meta['page'] ?? meta['current_page'] ?? 1,
      perPage: meta['per_page'] ?? meta['limit'] ?? 20,
      hasMore: meta['has_more'] ?? meta['has_next_page'] ?? false,
    );
  }
}

/// Products API Service
/// Handles product listing, search, filtering, and details
class ProductsApiService {
  final ApiClient _client;

  ProductsApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get all products with optional pagination and filters
  Future<ProductsResponse> getProducts({
    int page = 1,
    int perPage = 20,
    String? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    String? sortBy, // 'price', 'name', 'rating', 'newest'
    String? sortOrder, // 'asc', 'desc'
  }) async {
    final response = await _client.get(
      ApiConfig.products,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (categoryId != null) 'category_id': categoryId,
        if (brand != null) 'brand': brand,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      },
    );

    return ProductsResponse.fromJson(response.data);
  }

  /// Get a single product by ID
  Future<Product> getProduct(String id) async {
    final response = await _client.get('${ApiConfig.productDetail}/$id');
    return Product.fromJson(response.data['product'] ?? response.data);
  }

  /// Search products by query
  Future<ProductsResponse> searchProducts({
    required String query,
    int page = 1,
    int perPage = 20,
    String? categoryId,
  }) async {
    final response = await _client.get(
      ApiConfig.search,
      queryParameters: {
        'q': query,
        'page': page,
        'per_page': perPage,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    return ProductsResponse.fromJson(response.data);
  }

  /// Get featured products
  Future<List<Product>> getFeaturedProducts({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.featured,
      queryParameters: {'limit': limit},
    );

    final productsList =
        (response.data['products'] ?? response.data['data'] ?? []) as List;
    return productsList.map((e) => Product.fromJson(e)).toList();
  }

  /// Get new arrivals
  Future<List<Product>> getNewArrivals({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.newArrivals,
      queryParameters: {'limit': limit},
    );

    final productsList =
        (response.data['products'] ?? response.data['data'] ?? []) as List;
    return productsList.map((e) => Product.fromJson(e)).toList();
  }

  /// Get bestsellers
  Future<List<Product>> getBestsellers({int limit = 10}) async {
    final response = await _client.get(
      ApiConfig.bestsellers,
      queryParameters: {'limit': limit},
    );

    final productsList =
        (response.data['products'] ?? response.data['data'] ?? []) as List;
    return productsList.map((e) => Product.fromJson(e)).toList();
  }

  /// Get products by category
  Future<ProductsResponse> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    return getProducts(
      categoryId: categoryId,
      page: page,
      perPage: perPage,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Get all categories
  Future<List<Category>> getCategories() async {
    final response = await _client.get(ApiConfig.categories);

    final categoriesList =
        (response.data['categories'] ?? response.data['data'] ?? []) as List;
    return categoriesList.map((e) => Category.fromJson(e)).toList();
  }
}

/// Category model for API responses
class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final List<Category>? subcategories;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? json['image'],
      parentId: json['parent_id']?.toString(),
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
                .map((e) => Category.fromJson(e))
                .toList()
          : null,
    );
  }
}
