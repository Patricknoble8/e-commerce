/// Promo code discount type
enum DiscountType { percentage, fixedAmount, freeShipping }

/// Promo code model
class PromoCode {
  final String id;
  final String code;
  final String description;
  final DiscountType type;
  final double value; // Percentage (0-100) or fixed amount
  final double? minimumOrderAmount;
  final double? maximumDiscount;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final int? usageLimit;
  final int usedCount;
  final bool isActive;
  final List<String>? applicableCategories;
  final List<String>? applicableProducts;

  const PromoCode({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    this.minimumOrderAmount,
    this.maximumDiscount,
    this.validFrom,
    this.validUntil,
    this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
    this.applicableCategories,
    this.applicableProducts,
  });

  /// Check if promo code is valid
  bool get isValid {
    if (!isActive) return false;
    if (usageLimit != null && usedCount >= usageLimit!) return false;

    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;

    return true;
  }

  /// Calculate discount amount
  double calculateDiscount(double orderTotal) {
    if (!isValid) return 0;
    if (minimumOrderAmount != null && orderTotal < minimumOrderAmount!) {
      return 0;
    }

    double discount = 0;
    switch (type) {
      case DiscountType.percentage:
        discount = orderTotal * (value / 100);
        break;
      case DiscountType.fixedAmount:
        discount = value;
        break;
      case DiscountType.freeShipping:
        return 0; // Handled separately
    }

    if (maximumDiscount != null && discount > maximumDiscount!) {
      discount = maximumDiscount!;
    }

    return discount.clamp(0, orderTotal);
  }

  /// Get display string for the discount
  String get discountDisplayString {
    switch (type) {
      case DiscountType.percentage:
        return '${value.toInt()}% OFF';
      case DiscountType.fixedAmount:
        return '\$${value.toStringAsFixed(0)} OFF';
      case DiscountType.freeShipping:
        return 'FREE SHIPPING';
    }
  }

  PromoCode copyWith({
    String? id,
    String? code,
    String? description,
    DiscountType? type,
    double? value,
    double? minimumOrderAmount,
    double? maximumDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    int? usageLimit,
    int? usedCount,
    bool? isActive,
    List<String>? applicableCategories,
    List<String>? applicableProducts,
  }) {
    return PromoCode(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      maximumDiscount: maximumDiscount ?? this.maximumDiscount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
      applicableCategories: applicableCategories ?? this.applicableCategories,
      applicableProducts: applicableProducts ?? this.applicableProducts,
    );
  }
}
