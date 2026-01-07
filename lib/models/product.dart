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

  // Legacy categories (for backward compatibility)
  running,
  basketball,
  lifestyle,
  training,
  skate,
  casual,
  apparel,
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
}
