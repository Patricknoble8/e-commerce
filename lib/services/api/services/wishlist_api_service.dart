import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/product.dart';

/// Wishlist API Service
/// Handles wishlist/favorites operations
class WishlistApiService {
  final ApiClient _client;

  WishlistApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get user's wishlist
  Future<List<Product>> getWishlist() async {
    final response = await _client.get(ApiConfig.wishlist);

    final productsList =
        (response.data['products'] ?? response.data['items'] ?? []) as List;
    return productsList.map((e) => Product.fromJson(e)).toList();
  }

  /// Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    await _client.post(
      ApiConfig.addToWishlist,
      data: {'product_id': productId},
    );
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    await _client.delete('${ApiConfig.removeFromWishlist}/$productId');
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist(String productId) async {
    final wishlist = await getWishlist();
    return wishlist.any((p) => p.id == productId);
  }

  /// Toggle wishlist status
  Future<bool> toggleWishlist(String productId) async {
    final isInList = await isInWishlist(productId);
    if (isInList) {
      await removeFromWishlist(productId);
      return false;
    } else {
      await addToWishlist(productId);
      return true;
    }
  }
}
