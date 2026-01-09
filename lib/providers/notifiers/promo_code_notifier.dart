import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/promo_code.dart';
import '../../data/promo_code_data.dart';

/// Promo code state
class PromoCodeState {
  final PromoCode? appliedPromoCode;
  final bool isValidating;
  final String? error;
  final double discountAmount;

  const PromoCodeState({
    this.appliedPromoCode,
    this.isValidating = false,
    this.error,
    this.discountAmount = 0,
  });

  PromoCodeState copyWith({
    PromoCode? appliedPromoCode,
    bool? isValidating,
    String? error,
    double? discountAmount,
    bool clearPromoCode = false,
  }) {
    return PromoCodeState(
      appliedPromoCode: clearPromoCode
          ? null
          : (appliedPromoCode ?? this.appliedPromoCode),
      isValidating: isValidating ?? this.isValidating,
      error: error,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

/// Promo code notifier
class PromoCodeNotifier extends StateNotifier<PromoCodeState> {
  PromoCodeNotifier() : super(const PromoCodeState());

  /// Apply promo code
  Future<bool> applyPromoCode(String code, double orderTotal) async {
    if (code.isEmpty) {
      state = state.copyWith(error: 'Please enter a promo code');
      return false;
    }

    state = state.copyWith(isValidating: true, error: null);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final promoCode = PromoCodeData.validatePromoCode(code);

    if (promoCode == null) {
      state = state.copyWith(
        isValidating: false,
        error: 'Invalid or expired promo code',
      );
      return false;
    }

    if (promoCode.minimumOrderAmount != null &&
        orderTotal < promoCode.minimumOrderAmount!) {
      state = state.copyWith(
        isValidating: false,
        error:
            'Minimum order amount is \$${promoCode.minimumOrderAmount!.toStringAsFixed(0)}',
      );
      return false;
    }

    final discount = promoCode.calculateDiscount(orderTotal);

    state = PromoCodeState(
      appliedPromoCode: promoCode,
      isValidating: false,
      discountAmount: discount,
    );

    return true;
  }

  /// Remove promo code
  void removePromoCode() {
    state = const PromoCodeState();
  }

  /// Update discount amount (when cart changes)
  void updateDiscountAmount(double orderTotal) {
    if (state.appliedPromoCode != null) {
      final discount = state.appliedPromoCode!.calculateDiscount(orderTotal);
      state = state.copyWith(discountAmount: discount);
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Promo code provider
final promoCodeProvider =
    StateNotifierProvider<PromoCodeNotifier, PromoCodeState>(
      (ref) => PromoCodeNotifier(),
    );

/// Available promo codes provider
final availablePromoCodesProvider = Provider<List<PromoCode>>((ref) {
  return PromoCodeData.getActivePromoCodes();
});
