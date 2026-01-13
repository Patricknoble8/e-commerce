import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/product.dart';

void main() {
  const testProduct = Product(
    id: 'cart-test-1',
    name: 'Test Running Shoe',
    price: 150.0,
    imageUrl: 'https://example.com/shoe.jpg',
    description: 'Premium running shoe for testing',
    availableColors: ['Black', 'White', 'Red'],
    availableSizes: [38, 39, 40, 41, 42, 43],
    brand: 'TestBrand',
    discount: 20,
    category: ProductCategory.footwear,
  );

  const testProductNoDiscount = Product(
    id: 'cart-test-2',
    name: 'Test Casual Shoe',
    price: 100.0,
    imageUrl: 'https://example.com/casual.jpg',
    description: 'Casual shoe for testing',
    availableColors: ['Blue', 'Grey'],
    availableSizes: [40, 41, 42],
    brand: 'TestBrand',
    category: ProductCategory.footwear,
  );

  group('CartItem Model', () {
    test('should create cart item with required fields', () {
      const cartItem = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      expect(cartItem.product, testProduct);
      expect(cartItem.quantity, 1);
      expect(cartItem.selectedColor, 'Black');
      expect(cartItem.selectedSize, 42);
    });

    test('should calculate total price correctly with discount', () {
      const cartItem = CartItem(
        product: testProduct,
        quantity: 2,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      // Product price: 150, discount: 20%, final: 120
      // Quantity: 2, total: 240
      expect(cartItem.totalPrice, 240.0);
    });

    test('should calculate total price correctly without discount', () {
      const cartItem = CartItem(
        product: testProductNoDiscount,
        quantity: 3,
        selectedColor: 'Blue',
        selectedSize: 41,
      );

      // Product price: 100, no discount
      // Quantity: 3, total: 300
      expect(cartItem.totalPrice, 300.0);
    });

    test('copyWith should update specified fields', () {
      const cartItem = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      final updatedItem = cartItem.copyWith(
        quantity: 5,
        selectedColor: 'White',
      );

      expect(updatedItem.quantity, 5);
      expect(updatedItem.selectedColor, 'White');
      // Unchanged fields
      expect(updatedItem.product, testProduct);
      expect(updatedItem.selectedSize, 42);
    });

    test('copyWith with no arguments should return identical item', () {
      const cartItem = CartItem(
        product: testProduct,
        quantity: 2,
        selectedColor: 'Red',
        selectedSize: 40,
      );

      final copiedItem = cartItem.copyWith();

      expect(copiedItem.product, cartItem.product);
      expect(copiedItem.quantity, cartItem.quantity);
      expect(copiedItem.selectedColor, cartItem.selectedColor);
      expect(copiedItem.selectedSize, cartItem.selectedSize);
    });
  });

  group('CartItem Equality', () {
    test('items with same product, color, and size should be equal', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProduct,
        quantity: 5, // Different quantity
        selectedColor: 'Black',
        selectedSize: 42,
      );

      expect(cartItem1, equals(cartItem2));
    });

    test('items with different colors should not be equal', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'White',
        selectedSize: 42,
      );

      expect(cartItem1, isNot(equals(cartItem2)));
    });

    test('items with different sizes should not be equal', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 43,
      );

      expect(cartItem1, isNot(equals(cartItem2)));
    });

    test('items with different products should not be equal', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProductNoDiscount,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      expect(cartItem1, isNot(equals(cartItem2)));
    });
  });

  group('CartItem HashCode', () {
    test('equal items should have same hash code', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProduct,
        quantity: 3, // Different quantity doesn't affect equality
        selectedColor: 'Black',
        selectedSize: 42,
      );

      expect(cartItem1.hashCode, equals(cartItem2.hashCode));
    });

    test('different items should likely have different hash codes', () {
      const cartItem1 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'Black',
        selectedSize: 42,
      );

      const cartItem2 = CartItem(
        product: testProduct,
        quantity: 1,
        selectedColor: 'White',
        selectedSize: 43,
      );

      // Not guaranteed, but highly likely with good hash function
      expect(cartItem1.hashCode, isNot(equals(cartItem2.hashCode)));
    });
  });
}
