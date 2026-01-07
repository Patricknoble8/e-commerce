/// Payment method model
class PaymentMethod {
  final String id;
  final String type; // 'card', 'paypal', 'apple_pay', etc.
  final String name;
  final String? cardNumber; // Last 4 digits
  final String? expiryDate;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.cardNumber,
    this.expiryDate,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? name,
    String? cardNumber,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
