/// Category model for product categorization
/// Supports hierarchical structure with parent-child relationships
class Category {
  final String id;
  final String name;
  final String? emoji;
  final String? icon;
  final String? imageUrl;
  final String? description;
  final String? parentId;
  final List<Category> subcategories;
  final int displayOrder;

  const Category({
    required this.id,
    required this.name,
    this.emoji,
    this.icon,
    this.imageUrl,
    this.description,
    this.parentId,
    this.subcategories = const [],
    this.displayOrder = 0,
  });

  /// Check if this is a top-level category
  bool get isMainCategory => parentId == null;

  /// Check if this category has subcategories
  bool get hasSubcategories => subcategories.isNotEmpty;

  /// Get all leaf categories (categories without children)
  List<Category> get leafCategories {
    if (!hasSubcategories) return [this];
    return subcategories.expand((sub) => sub.leafCategories).toList();
  }

  /// Copy with method for immutability
  Category copyWith({
    String? id,
    String? name,
    String? emoji,
    String? icon,
    String? imageUrl,
    String? description,
    String? parentId,
    List<Category>? subcategories,
    int? displayOrder,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      subcategories: subcategories ?? this.subcategories,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
