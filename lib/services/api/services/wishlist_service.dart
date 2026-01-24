import '../api_client.dart';
import '../api_config.dart';
import '../../../models/product.dart';

/// Wishlist API Service
/// Handles wishlist/favorites operations
class WishlistService {
  final ApiClient _client;

  WishlistService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  /// Get user's wishlist
  Future<List<Product>> getWishlist() async {
    final response = await _client.get(ApiConfig.wishlist);
    final items = response.dataAsList;
    return items.map((item) => Product.fromJson(item)).toList();
  }

  /// Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    await _client.post('${ApiConfig.wishlist}/$productId');
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    await _client.delete('${ApiConfig.wishlist}/$productId');
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist(String productId) async {
    try {
      final response = await _client.get(
        '${ApiConfig.wishlist}/$productId/check',
      );
      return response.dataAsMap['inWishlist'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Clear entire wishlist
  Future<void> clearWishlist() async {
    await _client.delete(ApiConfig.wishlist);
  }

  /// Get wishlist count
  Future<int> getWishlistCount() async {
    final response = await _client.get('${ApiConfig.wishlist}/count');
    return response.dataAsMap['count'] ?? 0;
  }
}
