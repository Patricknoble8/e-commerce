/// Shipping address model
class ShippingAddress {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state $zipCode';

  /// Create from JSON
  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['label'] ?? '',
      street: json['street'] ?? json['address1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? json['province'] ?? '',
      zipCode: json['zipCode'] ?? json['zip'] ?? json['postalCode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'],
      isDefault: json['isDefault'] ?? json['default'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      if (phone != null) 'phone': phone,
      'isDefault': isDefault,
    };
  }

  ShippingAddress copyWith({
    String? id,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phone,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      name: name ?? this.name,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
