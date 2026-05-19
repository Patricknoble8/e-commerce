// Flutter widget tests for E-Commerce app
// Tests cover core functionality: cart, products, navigation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_commerce/main.dart';
import 'package:e_commerce/providers/notifiers/cart_notifier.dart';
import 'package:e_commerce/providers/api_providers.dart';
import 'package:e_commerce/providers/notifiers/product_notifier.dart';
import 'package:e_commerce/screens/auth/login_screen.dart';
import 'package:e_commerce/screens/auth/register_screen.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/data/product_data.dart';

void main() {
  group('App Launch Tests', () {
    testWidgets('App launches successfully with home screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
      expect(find.byType(RegisterScreen), findsNothing);
    });

    testWidgets('App has proper MaterialApp structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Cart Provider Tests', () {
    test('Cart starts empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cartState = container.read(cartProvider);

      expect(cartState.items, isEmpty);
      expect(cartState.itemCount, 0);
      expect(cartState.subtotal, 0.0);
    });

    test('Can add item to cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProduct = ProductData.products.first;

      container
          .read(cartProvider.notifier)
          .addToCart(
            testProduct,
            testProduct.availableColors.first,
            testProduct.availableSizes.first,
          );

      final cartState = container.read(cartProvider);

      expect(cartState.items.length, 1);
      expect(cartState.itemCount, 1);
      expect(cartState.items.first.product.id, testProduct.id);
    });

    test('Adding same item increases quantity', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProduct = ProductData.products.first;
      final color = testProduct.availableColors.first;
      final size = testProduct.availableSizes.first;

      container.read(cartProvider.notifier).addToCart(testProduct, color, size);
      container.read(cartProvider.notifier).addToCart(testProduct, color, size);

      final cartState = container.read(cartProvider);

      expect(cartState.items.length, 1);
      expect(cartState.items.first.quantity, 2);
    });

    test('Can remove item from cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProduct = ProductData.products.first;

      container
          .read(cartProvider.notifier)
          .addToCart(
            testProduct,
            testProduct.availableColors.first,
            testProduct.availableSizes.first,
          );

      final cartItem = container.read(cartProvider).items.first;
      container.read(cartProvider.notifier).removeFromCart(cartItem);

      final cartState = container.read(cartProvider);

      expect(cartState.items, isEmpty);
    });

    test('Clear cart removes all items', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add multiple products
      for (int i = 0; i < 3 && i < ProductData.products.length; i++) {
        final product = ProductData.products[i];
        container
            .read(cartProvider.notifier)
            .addToCart(
              product,
              product.availableColors.first,
              product.availableSizes.first,
            );
      }

      container.read(cartProvider.notifier).clearCart();

      final cartState = container.read(cartProvider);

      expect(cartState.items, isEmpty);
      expect(cartState.itemCount, 0);
    });

    test('Cart calculates subtotal correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProduct = ProductData.products.first;

      container
          .read(cartProvider.notifier)
          .addToCart(
            testProduct,
            testProduct.availableColors.first,
            testProduct.availableSizes.first,
          );

      final cartState = container.read(cartProvider);
      final expectedPrice = testProduct.finalPrice;

      expect(cartState.subtotal, expectedPrice);
    });
  });

  group('Product Provider Tests', () {
    test('Product list is not empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final products = container.read(productListProvider);

      expect(products, isNotEmpty);
    });

    test('Can filter products by search query', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set a search query
      container.read(searchQueryProvider.notifier).state = 'nike';

      final filteredProducts = container.read(filteredProductsProvider);

      // All filtered products should contain 'nike' in name, brand, or description
      for (final product in filteredProducts) {
        final matchesQuery =
            product.name.toLowerCase().contains('nike') ||
            product.brand.toLowerCase().contains('nike') ||
            product.description.toLowerCase().contains('nike');
        expect(matchesQuery, isTrue);
      }
    });

    test('Empty search returns all products', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = '';

      final filteredProducts = container.read(filteredProductsProvider);
      final allProducts = container.read(productListProvider);

      expect(filteredProducts.length, allProducts.length);
    });
  });

  group('Favorites Provider Tests', () {
    test('Favorites starts empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final favorites = container.read(favoritesProvider);

      expect(favorites, isEmpty);
    });

    test('Can toggle favorite', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final productId = ProductData.products.first.id;

      container.read(favoritesProvider.notifier).toggleFavorite(productId);
      expect(container.read(favoritesProvider).contains(productId), isTrue);

      container.read(favoritesProvider.notifier).toggleFavorite(productId);
      expect(container.read(favoritesProvider).contains(productId), isFalse);
    });

    test('isFavorite returns correct state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final productId = ProductData.products.first.id;

      expect(
        container.read(favoritesProvider.notifier).isFavorite(productId),
        isFalse,
      );

      container.read(favoritesProvider.notifier).toggleFavorite(productId);

      expect(
        container.read(favoritesProvider.notifier).isFavorite(productId),
        isTrue,
      );
    });
  });

  group('Product Model Tests', () {
    test('Product has required fields', () {
      final product = ProductData.products.first;

      expect(product.id, isNotEmpty);
      expect(product.name, isNotEmpty);
      expect(product.brand, isNotEmpty);
      expect(product.price, greaterThan(0));
      expect(product.imageUrl, isNotEmpty);
    });

    test('Product calculates final price correctly', () {
      // Create a product with a discount
      const product = Product(
        id: 'test-1',
        name: 'Test Product',
        brand: 'Test Brand',
        description: 'Test description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        discount: 20, // 20% discount
        category: ProductCategory.clothing,
        rating: 4.5,
        reviewCount: 10,
        availableColors: ['Black'],
        availableSizes: [42],
      );

      expect(product.hasDiscount, isTrue);
      expect(product.finalPrice, 80.0); // 100 - 20%
    });

    test('Product without discount has same final price', () {
      const product = Product(
        id: 'test-2',
        name: 'Test Product',
        brand: 'Test Brand',
        description: 'Test description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        category: ProductCategory.clothing,
        rating: 4.5,
        reviewCount: 10,
        availableColors: ['Black'],
        availableSizes: [42],
      );

      expect(product.hasDiscount, isFalse);
      expect(product.finalPrice, 100.0);
    });
  });
}
