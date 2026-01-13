import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/models/user.dart';

void main() {
  group('User Model', () {
    const testUser = User(
      id: 'user-1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      avatarUrl: 'https://example.com/avatar.jpg',
      membershipTier: 'Gold',
      loyaltyPoints: 1500,
      totalOrders: 25,
      totalReviews: 10,
      walletBalance: 150.50,
    );

    test('should create user with required fields', () {
      const minimalUser = User(
        id: 'user-2',
        name: 'Jane Smith',
        email: 'jane@example.com',
      );

      expect(minimalUser.id, 'user-2');
      expect(minimalUser.name, 'Jane Smith');
      expect(minimalUser.email, 'jane@example.com');
    });

    test('should have correct default values', () {
      const minimalUser = User(
        id: 'user-3',
        name: 'Test User',
        email: 'test@example.com',
      );

      expect(minimalUser.phone, isNull);
      expect(minimalUser.avatarUrl, isNull);
      expect(minimalUser.membershipTier, 'Bronze');
      expect(minimalUser.loyaltyPoints, 0);
      expect(minimalUser.totalOrders, 0);
      expect(minimalUser.totalReviews, 0);
      expect(minimalUser.walletBalance, 0.0);
    });

    test('should store all provided fields', () {
      expect(testUser.id, 'user-1');
      expect(testUser.name, 'John Doe');
      expect(testUser.email, 'john.doe@example.com');
      expect(testUser.phone, '+1234567890');
      expect(testUser.avatarUrl, 'https://example.com/avatar.jpg');
      expect(testUser.membershipTier, 'Gold');
      expect(testUser.loyaltyPoints, 1500);
      expect(testUser.totalOrders, 25);
      expect(testUser.totalReviews, 10);
      expect(testUser.walletBalance, 150.50);
    });

    test('copyWith should update specified fields', () {
      final updatedUser = testUser.copyWith(
        name: 'John Updated',
        email: 'john.updated@example.com',
        membershipTier: 'Platinum',
        loyaltyPoints: 5000,
      );

      expect(updatedUser.name, 'John Updated');
      expect(updatedUser.email, 'john.updated@example.com');
      expect(updatedUser.membershipTier, 'Platinum');
      expect(updatedUser.loyaltyPoints, 5000);
      // Unchanged fields
      expect(updatedUser.id, testUser.id);
      expect(updatedUser.phone, testUser.phone);
      expect(updatedUser.totalOrders, testUser.totalOrders);
    });

    test('copyWith with no arguments should preserve all fields', () {
      final copiedUser = testUser.copyWith();

      expect(copiedUser.id, testUser.id);
      expect(copiedUser.name, testUser.name);
      expect(copiedUser.email, testUser.email);
      expect(copiedUser.phone, testUser.phone);
      expect(copiedUser.membershipTier, testUser.membershipTier);
      expect(copiedUser.loyaltyPoints, testUser.loyaltyPoints);
    });
  });

  group('User JSON Serialization', () {
    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'json-user-1',
        'name': 'JSON User',
        'email': 'json@example.com',
        'phone': '+9876543210',
        'avatar_url': 'https://example.com/json-avatar.jpg',
        'membership_tier': 'Silver',
        'loyalty_points': 750,
        'total_orders': 12,
        'total_reviews': 5,
        'wallet_balance': 75.25,
      };

      final user = User.fromJson(json);

      expect(user.id, 'json-user-1');
      expect(user.name, 'JSON User');
      expect(user.email, 'json@example.com');
      expect(user.phone, '+9876543210');
      expect(user.avatarUrl, 'https://example.com/json-avatar.jpg');
      expect(user.membershipTier, 'Silver');
      expect(user.loyaltyPoints, 750);
      expect(user.totalOrders, 12);
      expect(user.totalReviews, 5);
      expect(user.walletBalance, 75.25);
    });

    test('should handle alternative JSON keys', () {
      final json = {
        'id': 'alt-user-1',
        'full_name': 'Alternative Name',
        'email': 'alt@example.com',
        'avatar': 'https://example.com/alt-avatar.jpg',
        'tier': 'Gold',
        'points': 2000,
        'orders_count': 30,
        'reviews_count': 15,
        'balance': 200.0,
      };

      final user = User.fromJson(json);

      expect(user.name, 'Alternative Name');
      expect(user.avatarUrl, 'https://example.com/alt-avatar.jpg');
      expect(user.membershipTier, 'Gold');
      expect(user.loyaltyPoints, 2000);
      expect(user.totalOrders, 30);
      expect(user.totalReviews, 15);
      expect(user.walletBalance, 200.0);
    });

    test('should handle missing optional fields in JSON', () {
      final json = {
        'id': 'minimal-user-1',
        'name': 'Minimal User',
        'email': 'minimal@example.com',
      };

      final user = User.fromJson(json);

      expect(user.id, 'minimal-user-1');
      expect(user.name, 'Minimal User');
      expect(user.email, 'minimal@example.com');
      expect(user.phone, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.membershipTier, 'Bronze');
      expect(user.loyaltyPoints, 0);
      expect(user.totalOrders, 0);
      expect(user.totalReviews, 0);
      expect(user.walletBalance, 0.0);
    });

    test('should handle null values in JSON gracefully', () {
      final json = {
        'id': null,
        'name': null,
        'email': null,
        'phone': null,
        'loyalty_points': null,
      };

      final user = User.fromJson(json);

      expect(user.id, '');
      expect(user.name, '');
      expect(user.email, '');
      expect(user.phone, isNull);
      expect(user.loyaltyPoints, 0);
    });
  });

  group('User Membership Tiers', () {
    test('should accept valid membership tiers', () {
      const tiers = ['Bronze', 'Silver', 'Gold', 'Platinum'];

      for (final tier in tiers) {
        final user = User(
          id: 'tier-user',
          name: 'Tier User',
          email: 'tier@example.com',
          membershipTier: tier,
        );

        expect(user.membershipTier, tier);
      }
    });
  });
}
