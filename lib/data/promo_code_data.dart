import '../models/promo_code.dart';

/// Demo promo code data
class PromoCodeData {
  static List<PromoCode> getPromoCodes() {
    final now = DateTime.now();

    return [
      PromoCode(
        id: '1',
        code: 'WELCOME10',
        description: '10% off for new customers',
        type: DiscountType.percentage,
        value: 10,
        minimumOrderAmount: 50,
        validFrom: now.subtract(const Duration(days: 30)),
        validUntil: now.add(const Duration(days: 60)),
        usageLimit: 1,
        usedCount: 0,
        isActive: true,
      ),
      PromoCode(
        id: '2',
        code: 'SAVE20',
        description: '20% off on orders over \$100',
        type: DiscountType.percentage,
        value: 20,
        minimumOrderAmount: 100,
        maximumDiscount: 50,
        validFrom: now.subtract(const Duration(days: 7)),
        validUntil: now.add(const Duration(days: 30)),
        isActive: true,
      ),
      PromoCode(
        id: '3',
        code: 'FREESHIP',
        description: 'Free shipping on orders over \$75',
        type: DiscountType.freeShipping,
        value: 0,
        minimumOrderAmount: 75,
        validFrom: now.subtract(const Duration(days: 14)),
        validUntil: now.add(const Duration(days: 14)),
        isActive: true,
      ),
      PromoCode(
        id: '4',
        code: 'SAVE50',
        description: '\$50 off on orders over \$200',
        type: DiscountType.fixedAmount,
        value: 50,
        minimumOrderAmount: 200,
        validFrom: now.subtract(const Duration(days: 3)),
        validUntil: now.add(const Duration(days: 10)),
        isActive: true,
      ),
      PromoCode(
        id: '5',
        code: 'SUMMER25',
        description: '25% off summer collection',
        type: DiscountType.percentage,
        value: 25,
        maximumDiscount: 100,
        validFrom: now.subtract(const Duration(days: 5)),
        validUntil: now.add(const Duration(days: 45)),
        applicableCategories: ['fashion', 'footwear'],
        isActive: true,
      ),
      PromoCode(
        id: '6',
        code: 'TECH15',
        description: '15% off electronics',
        type: DiscountType.percentage,
        value: 15,
        minimumOrderAmount: 100,
        applicableCategories: [
          'electronics',
          'smartphones',
          'laptops',
          'audio',
        ],
        validFrom: now.subtract(const Duration(days: 10)),
        validUntil: now.add(const Duration(days: 20)),
        isActive: true,
      ),
      // Expired promo code
      PromoCode(
        id: '7',
        code: 'EXPIRED20',
        description: '20% off - Expired',
        type: DiscountType.percentage,
        value: 20,
        validFrom: now.subtract(const Duration(days: 30)),
        validUntil: now.subtract(const Duration(days: 1)),
        isActive: true,
      ),
    ];
  }

  /// Validate and get promo code
  static PromoCode? validatePromoCode(String code) {
    try {
      final promo = getPromoCodes().firstWhere(
        (p) => p.code.toUpperCase() == code.toUpperCase(),
      );
      if (promo.isValid) {
        return promo;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get all active promo codes
  static List<PromoCode> getActivePromoCodes() {
    return getPromoCodes().where((p) => p.isValid).toList();
  }
}
