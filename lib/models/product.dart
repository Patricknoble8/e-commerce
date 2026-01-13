/// Product categories for filtering
enum ProductCategory {
  // Fashion & Apparel
  clothing,
  footwear,
  accessories,
  watches,
  eyewear,

  // Electronics
  smartphones,
  laptops,
  audio,
  gaming,
  smartHome,
  wearables,

  // Home & Living
  furniture,
  decor,
  kitchen,
  lighting,

  // Beauty & Personal Care
  skincare,
  makeup,
  haircare,
  fragrance,

  // Sports & Fitness
  sportswear,
  fitnessEquipment,
  outdoorGear,

  // Books & Media
  books,

  // Food & Beverages
  food,
  beverages,

  // Baby & Kids
  babyClothing,
  toys,

  // Pet Supplies
  petSupplies,

  // Digital Products
  software,
  courses,

  // Services
  subscriptions,
}

/// Product model representing an item in the e-commerce app
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> availableColors;
  final List<dynamic> availableSizes; // Can be int (shoes) or String (clothing)
  final String brand;
  final double? discount;
  final ProductCategory category;
  final String? categoryId; // Links to Category.id for hierarchical categories
  final String? subcategoryId; // Links to subcategory for filtering
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.availableColors,
    required this.availableSizes,
    required this.brand,
    this.discount,
    required this.category,
    this.categoryId,
    this.subcategoryId,
    this.rating = 4.5,
    this.reviewCount = 0,
  });

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    List<String>? availableColors,
    List<int>? availableSizes,
    String? brand,
    double? discount,
    ProductCategory? category,
    String? categoryId,
    String? subcategoryId,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      availableColors: availableColors ?? this.availableColors,
      availableSizes: availableSizes ?? this.availableSizes,
      brand: brand ?? this.brand,
      discount: discount ?? this.discount,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  /// Create Product from JSON response
  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse category
    ProductCategory category = ProductCategory.clothing;
    if (json['category'] != null) {
      final categoryStr = json['category'].toString().toLowerCase();
      try {
        category = ProductCategory.values.firstWhere(
          (e) => e.name.toLowerCase() == categoryStr,
          orElse: () => ProductCategory.clothing,
        );
      } catch (_) {
        category = ProductCategory.clothing;
      }
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      description: json['description'] ?? '',
      availableColors: json['available_colors'] != null
          ? List<String>.from(json['available_colors'])
          : json['colors'] != null
          ? List<String>.from(json['colors'])
          : [],
      availableSizes: json['available_sizes'] ?? json['sizes'] ?? [],
      brand: json['brand'] ?? '',
      discount: json['discount']?.toDouble(),
      category: category,
      categoryId: json['category_id']?.toString(),
      subcategoryId: json['subcategory_id']?.toString(),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['review_count'] ?? json['reviews_count'] ?? 0,
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'available_colors': availableColors,
      'available_sizes': availableSizes,
      'brand': brand,
      'discount': discount,
      'category': category.name,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}
