import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/shipping_address.dart';

/// Addresses API Service
/// Handles shipping address CRUD operations
class AddressesApiService {
  final ApiClient _client;

  AddressesApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get all addresses for current user
  Future<List<ShippingAddress>> getAddresses() async {
    final response = await _client.get(ApiConfig.addresses);

    final addressesList =
        (response.data['addresses'] ?? response.data['data'] ?? []) as List;
    return addressesList.map((e) => _addressFromJson(e)).toList();
  }

  /// Get default address
  Future<ShippingAddress?> getDefaultAddress() async {
    final addresses = await getAddresses();
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Add a new address
  Future<ShippingAddress> addAddress({
    required String name,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    String? phone,
    bool isDefault = false,
  }) async {
    final response = await _client.post(
      ApiConfig.addAddress,
      data: {
        'name': name,
        'street': street,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'country': country,
        if (phone != null) 'phone': phone,
        'is_default': isDefault,
      },
    );

    return _addressFromJson(response.data['address'] ?? response.data);
  }

  /// Update an existing address
  Future<ShippingAddress> updateAddress({
    required String addressId,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phone,
    bool? isDefault,
  }) async {
    final response = await _client.put(
      '${ApiConfig.updateAddress}/$addressId',
      data: {
        if (name != null) 'name': name,
        if (street != null) 'street': street,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zip_code': zipCode,
        if (country != null) 'country': country,
        if (phone != null) 'phone': phone,
        if (isDefault != null) 'is_default': isDefault,
      },
    );

    return _addressFromJson(response.data['address'] ?? response.data);
  }

  /// Delete an address
  Future<void> deleteAddress(String addressId) async {
    await _client.delete('${ApiConfig.deleteAddress}/$addressId');
  }

  /// Set an address as default
  Future<void> setDefaultAddress(String addressId) async {
    await _client.post(
      ApiConfig.setDefaultAddress,
      data: {'address_id': addressId},
    );
  }

  /// Parse address from JSON
  ShippingAddress _addressFromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      street: json['street'] ?? json['address_line1'] ?? json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? json['postal_code'] ?? json['zip'] ?? '',
      country: json['country'] ?? 'USA',
      phone: json['phone'],
      isDefault: json['is_default'] ?? false,
    );
  }
}
