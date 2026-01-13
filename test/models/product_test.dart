import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/data/product_data.dart';

void main() {
  group('ProductCategory', () {
    test('should have expected categories', () {
      expect(ProductCategory.values, contains(ProductCategory.clothing));
      expect(ProductCategory.values, contains(ProductCategory.footwear));
      expect(ProductCategory.values, contains(ProductCategory.accessories));
      expect(ProductCategory.values, contains(ProductCategory.smartphones));
      expect(ProductCategory.values, contains(ProductCategory.laptops));
      expect(ProductCategory.values, contains(ProductCategory.audio));
      expect(ProductCategory.values, contains(ProductCategory.furniture));
      expect(ProductCategory.values, contains(ProductCategory.skincare));
    });

    test('should not contain legacy categories', () {
      final categoryNames = ProductCategory.values.map((e) => e.name).toList();
      expect(categoryNames, isNot(contains('casual')));
      expect(categoryNames, isNot(contains('lifestyle')));
      expect(categoryNames, isNot(contains('running')));
      expect(categoryNames, isNot(contains('skate')));
      expect(categoryNames, isNot(contains('basketball')));
      expect(categoryNames, isNot(contains('training')));
      expect(categoryNames, isNot(contains('apparel')));
    });
  });

  group('Product Model', () {
    const testProduct = Product(
      id: 'test-1',
      name: 'Test Sneakers',
      price: 150.0,
      imageUrl: 'https://example.com/image.jpg',
      description: 'Premium test sneakers for testing',
      availableColors: ['Black', 'White', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'TestBrand',
      discount: 20,
      category: ProductCategory.footwear,
      rating: 4.5,
      reviewCount: 100,
    );

    test('should create product with required fields', () {
      expect(testProduct.id, 'test-1');
      expect(testProduct.name, 'Test Sneakers');
      expect(testProduct.price, 150.0);
      expect(testProduct.brand, 'TestBrand');
      expect(testProduct.category, ProductCategory.footwear);
    });

    test('should calculate final price with discount', () {
      expect(testProduct.hasDiscount, isTrue);
      expect(testProduct.discount, 20);
      expect(testProduct.finalPrice, 120.0); // 150 - 20% = 120
    });

    test('should return original price when no discount', () {
      const productNoDiscount = Product(
        id: 'test-2',
        name: 'No Discount Product',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        availableColors: ['Black'],
        availableSizes: [42],
        brand: 'TestBrand',
        category: ProductCategory.footwear,
      );

      expect(productNoDiscount.hasDiscount, isFalse);
      expect(productNoDiscount.finalPrice, 100.0);
    });

    test('should return original price when discount is zero', () {
      const productZeroDiscount = Product(
        id: 'test-3',
        name: 'Zero Discount Product',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        availableColors: ['Black'],
        availableSizes: [42],
        brand: 'TestBrand',
        discount: 0,
        category: ProductCategory.footwear,
      );

      expect(productZeroDiscount.hasDiscount, isFalse);
      expect(productZeroDiscount.finalPrice, 100.0);
    });

    test('should have default rating of 4.5', () {
      const productDefaultRating = Product(
        id: 'test-4',
        name: 'Default Rating Product',
        price: 50.0,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        availableColors: ['Black'],
        availableSizes: [42],
        brand: 'TestBrand',
        category: ProductCategory.footwear,
      );

      expect(productDefaultRating.rating, 4.5);
      expect(productDefaultRating.reviewCount, 0);
    });

    test('copyWith should update specified fields', () {
      final updatedProduct = testProduct.copyWith(
        name: 'Updated Sneakers',
        price: 200.0,
        discount: 30,
      );

      expect(updatedProduct.name, 'Updated Sneakers');
      expect(updatedProduct.price, 200.0);
      expect(updatedProduct.discount, 30);
      // Unchanged fields
      expect(updatedProduct.id, testProduct.id);
      expect(updatedProduct.brand, testProduct.brand);
      expect(updatedProduct.category, testProduct.category);
    });

    test('should serialize to JSON correctly', () {
      final json = testProduct.toJson();

      expect(json['id'], 'test-1');
      expect(json['name'], 'Test Sneakers');
      expect(json['price'], 150.0);
      expect(json['brand'], 'TestBrand');
      expect(json['discount'], 20);
      expect(json['category'], 'footwear');
      expect(json['rating'], 4.5);
      expect(json['review_count'], 100);
      expect(json['available_colors'], ['Black', 'White', 'Red']);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'json-1',
        'name': 'JSON Product',
        'price': 99.99,
        'image_url': 'https://example.com/img.jpg',
        'description': 'From JSON',
        'available_colors': ['Blue', 'Green'],
        'available_sizes': [40, 41, 42],
        'brand': 'JSONBrand',
        'discount': 15.0,
        'category': 'footwear',
        'rating': 4.2,
        'review_count': 50,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'json-1');
      expect(product.name, 'JSON Product');
      expect(product.price, 99.99);
      expect(product.brand, 'JSONBrand');
      expect(product.discount, 15.0);
      expect(product.category, ProductCategory.footwear);
      expect(product.rating, 4.2);
      expect(product.reviewCount, 50);
    });

    test('should handle missing optional fields in JSON', () {
      final json = {
        'id': 'minimal-1',
        'name': 'Minimal Product',
        'price': 50,
        'description': 'Minimal description',
        'brand': 'MinimalBrand',
      };

      final product = Product.fromJson(json);

      expect(product.id, 'minimal-1');
      expect(product.name, 'Minimal Product');
      expect(product.availableColors, isEmpty);
      expect(product.availableSizes, isEmpty);
      expect(product.discount, isNull);
      expect(product.rating, 4.5); // Default
    });
  });

  group('ProductData', () {
    test('should have products defined', () {
      expect(ProductData.products, isNotEmpty);
    });

    test('all products should have valid categories', () {
      for (final product in ProductData.products) {
        expect(
          ProductCategory.values.contains(product.category),
          isTrue,
          reason: 'Product ${product.name} has invalid category',
        );
      }
    });

    test('all products should have valid IDs', () {
      for (final product in ProductData.products) {
        expect(product.id, isNotEmpty);
      }
    });

    test('all products should have valid prices', () {
      for (final product in ProductData.products) {
        expect(
          product.price,
          greaterThan(0),
          reason: 'Product ${product.name} has invalid price',
        );
      }
    });

    test('all products should have valid brands', () {
      for (final product in ProductData.products) {
        expect(
          product.brand,
          isNotEmpty,
          reason: 'Product ${product.name} is missing brand',
        );
      }
    });

    test('discounts should be between 0 and 100', () {
      for (final product in ProductData.products) {
        if (product.discount != null) {
          expect(
            product.discount,
            greaterThanOrEqualTo(0),
            reason: 'Product ${product.name} has negative discount',
          );
          expect(
            product.discount,
            lessThanOrEqualTo(100),
            reason: 'Product ${product.name} has discount over 100%',
          );
        }
      }
    });

    test('sneaker products should use footwear category', () {
      final sneakerBrands = [
        'Nike',
        'Adidas',
        'Puma',
        'New Balance',
        'Converse',
        'Vans',
      ];
      final sneakerProducts = ProductData.products.where(
        (p) =>
            sneakerBrands.contains(p.brand) &&
            (p.name.toLowerCase().contains('shoe') ||
                p.name.toLowerCase().contains('sneaker') ||
                p.name.toLowerCase().contains('air') ||
                p.name.toLowerCase().contains('boost') ||
                p.name.toLowerCase().contains('jordan') ||
                p.name.toLowerCase().contains('dunk') ||
                p.name.toLowerCase().contains('suede') ||
                p.name.toLowerCase().contains('old skool') ||
                p.name.toLowerCase().contains('chuck')),
      );

      for (final product in sneakerProducts) {
        expect(
          product.category,
          ProductCategory.footwear,
          reason: 'Sneaker "${product.name}" should be in footwear category',
        );
      }
    });
  });
}
