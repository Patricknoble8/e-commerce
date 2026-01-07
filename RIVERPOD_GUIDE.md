# 🔄 Riverpod State Management Documentation

## Overview

This e-commerce app uses **Riverpod** for state management, following best practices and professional architecture patterns. Riverpod is a complete rewrite of Provider, offering compile-time safety, better testability, and more flexibility.

---

## 📁 Riverpod Structure

```
lib/providers/
├── state/
│   └── cart_state.dart              # Cart state class
├── notifiers/
│   ├── cart_notifier.dart           # Cart state notifier + providers
│   └── product_notifier.dart        # Product and favorites notifiers
└── providers.dart                    # Export file for all providers
```

---

## 🎯 Core Concepts

### 1. State Classes (`state/`)
Immutable state classes that hold the application state.

**Example: CartState**
```dart
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  // Computed properties
  int get itemCount => ...;
  double get subtotal => ...;
  double get total => ...;
}
```

### 2. State Notifiers (`notifiers/`)
Classes that manage state mutations and business logic.

**Example: CartNotifier**
```dart
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addToCart(Product product, String color, int size) {
    // Business logic here
    state = state.copyWith(items: updatedItems);
  }
}
```

### 3. Providers
Global objects that expose state and notifiers to the widget tree.

**Types Used:**
- `StateNotifierProvider` - For stateful logic (cart, favorites)
- `Provider` - For computed/derived values
- `Provider.family` - For providers with parameters

---

## 📦 Available Providers

### Cart Providers (`cart_notifier.dart`)

#### `cartProvider`
**Type**: `StateNotifierProvider<CartNotifier, CartState>`

Main cart state provider with full CRUD operations.

**Usage:**
```dart
// Read state
final cartState = ref.watch(cartProvider);

// Perform actions
ref.read(cartProvider.notifier).addToCart(product, color, size);
ref.read(cartProvider.notifier).removeFromCart(item);
ref.read(cartProvider.notifier).updateQuantity(item, quantity);
ref.read(cartProvider.notifier).clearCart();
```

**Available Methods:**
- `addToCart(Product, String color, int size)` - Add product to cart
- `removeFromCart(CartItem)` - Remove item from cart
- `updateQuantity(CartItem, int)` - Update item quantity
- `clearCart()` - Remove all items
- `isInCart(String productId)` - Check if product in cart
- `getProductCount(String productId)` - Get quantity of specific product

#### `cartItemCountProvider`
**Type**: `Provider<int>`

Computed provider for total item count in cart.

**Usage:**
```dart
final itemCount = ref.watch(cartItemCountProvider);
// Returns: 5 (if 5 total items in cart)
```

#### `cartSubtotalProvider`
**Type**: `Provider<double>`

Computed provider for cart subtotal (before delivery).

**Usage:**
```dart
final subtotal = ref.watch(cartSubtotalProvider);
// Returns: 750.0
```

#### `cartTotalProvider`
**Type**: `Provider<double>`

Computed provider for final cart total (with delivery).

**Usage:**
```dart
final total = ref.watch(cartTotalProvider);
// Returns: 800.0
```

#### `cartDeliveryChargeProvider`
**Type**: `Provider<double>`

Computed provider for delivery charge.

**Usage:**
```dart
final deliveryCharge = ref.watch(cartDeliveryChargeProvider);
// Returns: 50.0 (or 0 if cart empty)
```

---

### Product Providers (`product_notifier.dart`)

#### `productListProvider`
**Type**: `Provider<List<Product>>`

Provides the complete list of products.

**Usage:**
```dart
final products = ref.watch(productListProvider);
```

#### `productByIdProvider`
**Type**: `Provider.family<Product, String>`

Get a specific product by ID.

**Usage:**
```dart
final product = ref.watch(productByIdProvider('product_1'));
```

#### `productsByCategoryProvider`
**Type**: `Provider.family<List<Product>, String>`

Filter products by category.

**Usage:**
```dart
final menShoes = ref.watch(productsByCategoryProvider('Men'));
```

#### `favoritesProvider`
**Type**: `StateNotifierProvider<FavoritesNotifier, Set<String>>`

Manage favorite products.

**Usage:**
```dart
// Read favorites
final favorites = ref.watch(favoritesProvider);

// Toggle favorite
ref.read(favoritesProvider.notifier).toggleFavorite(productId);

// Check if favorite
final isFav = ref.read(favoritesProvider.notifier).isFavorite(productId);

// Clear all
ref.read(favoritesProvider.notifier).clearFavorites();
```

#### `favoriteProductsProvider`
**Type**: `Provider<List<Product>>`

Get list of favorited products.

**Usage:**
```dart
final favoriteProducts = ref.watch(favoriteProductsProvider);
```

---

## 🔧 Usage Patterns

### In Screens

Convert `StatefulWidget` to `ConsumerStatefulWidget`:

**Before (Provider):**
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Widget();
  }
}
```

**After (Riverpod):**
```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    return Widget();
  }
}
```

### Reading State

#### `ref.watch()`
Subscribes to changes. Widget rebuilds when state changes.

```dart
// Use in build method
final cart = ref.watch(cartProvider);
final itemCount = ref.watch(cartItemCountProvider);
```

#### `ref.read()`
One-time read without subscription. Use for callbacks.

```dart
// Use in event handlers
onPressed: () {
  ref.read(cartProvider.notifier).addToCart(product, color, size);
}
```

#### `ref.listen()`
Listen to changes without rebuilding widget.

```dart
@override
void initState() {
  super.initState();
  ref.listen(cartProvider, (previous, next) {
    if (next.error != null) {
      showErrorDialog(next.error!);
    }
  });
}
```

---

## 🏗️ Screen Examples

### Home Screen
```dart
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final favorites = ref.watch(favoritesProvider);

    return GridView.builder(
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          isFavorite: favorites.contains(product.id),
          onFavoriteToggle: () {
            ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
          },
        );
      },
    );
  }
}
```

### Product Detail Screen
```dart
class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  
  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedColor;
  int? _selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Product details...
          PrimaryButton(
            text: 'Add to Cart',
            onPressed: () {
              ref.read(cartProvider.notifier).addToCart(
                widget.product,
                _selectedColor!,
                _selectedSize!,
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Cart Screen
```dart
class CartScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      body: Column(
        children: [
          ...cartState.items.map((item) => CartItemWidget(
            item: item,
            onDelete: () {
              ref.read(cartProvider.notifier).removeFromCart(item);
            },
            onQuantityChange: (newQty) {
              ref.read(cartProvider.notifier).updateQuantity(item, newQty);
            },
          )),
          OrderSummary(subtotal: subtotal, total: total),
        ],
      ),
    );
  }
}
```

---

## ⚡ Performance Optimization

### 1. Use Computed Providers
Instead of deriving values in the widget, use computed providers:

**❌ Bad:**
```dart
Widget build(BuildContext context) {
  final cart = ref.watch(cartProvider);
  final total = cart.items.fold(0, (sum, item) => sum + item.totalPrice);
  // Widget rebuilds even if total hasn't changed
}
```

**✅ Good:**
```dart
Widget build(BuildContext context) {
  final total = ref.watch(cartTotalProvider);
  // Only rebuilds when total actually changes
}
```

### 2. Use `select` for Granular Updates
Watch only specific parts of state:

```dart
// Rebuilds only when item count changes
final itemCount = ref.watch(cartProvider.select((state) => state.itemCount));
```

### 3. Use `ref.read()` in Callbacks
Avoid unnecessary widget rebuilds:

```dart
// ✅ Good - no rebuild subscription
onPressed: () {
  ref.read(cartProvider.notifier).addToCart(...);
}

// ❌ Bad - creates unnecessary subscription
onPressed: () {
  ref.watch(cartProvider.notifier).addToCart(...);
}
```

---

## 🧪 Testing

Riverpod makes testing easy with `ProviderContainer`:

```dart
test('cart adds items correctly', () {
  final container = ProviderContainer();
  final notifier = container.read(cartProvider.notifier);

  notifier.addToCart(testProduct, 'Blue', 42);

  final state = container.read(cartProvider);
  expect(state.items.length, 1);
  expect(state.itemCount, 1);
});
```

Override providers in tests:

```dart
testWidgets('displays cart items', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        cartProvider.overrideWith((ref) => MockCartNotifier()),
      ],
      child: CartScreen(),
    ),
  );
});
```

---

## 🎯 Best Practices

### 1. **Provider Organization**
- State classes in `state/` folder
- Notifiers in `notifiers/` folder
- Single export file (`providers.dart`)

### 2. **Naming Conventions**
- State classes: `*State` (e.g., `CartState`)
- Notifiers: `*Notifier` (e.g., `CartNotifier`)
- Providers: `*Provider` (e.g., `cartProvider`)

### 3. **Immutability**
Always use `copyWith` to update state:

```dart
// ✅ Good
state = state.copyWith(items: newItems);

// ❌ Bad - mutates state directly
state.items.add(newItem);
```

### 4. **Single Responsibility**
Each notifier handles one domain:
- `CartNotifier` - Cart operations only
- `FavoritesNotifier` - Favorites only
- Keep business logic in notifiers, not widgets

### 5. **Error Handling**
Include error state in your state classes:

```dart
class CartState {
  final String? error;
  final bool isLoading;
  
  // Handle errors gracefully
}
```

---

## 🔄 Migration from Provider

### Key Changes

1. **Imports**
```dart
// Old
import 'package:provider/provider.dart';

// New
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

2. **Widget Types**
```dart
// Old
StatefulWidget → State

// New
ConsumerStatefulWidget → ConsumerState
```

3. **Context Access**
```dart
// Old
context.watch<CartProvider>()
context.read<CartProvider>()

// New
ref.watch(cartProvider)
ref.read(cartProvider.notifier)
```

4. **App Setup**
```dart
// Old
MultiProvider(
  providers: [...],
  child: MyApp(),
)

// New
ProviderScope(
  child: MyApp(),
)
```

---

## 📚 Additional Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Best Practices](https://codewithandrea.com/articles/flutter-state-management-riverpod/)
- [Testing with Riverpod](https://riverpod.dev/docs/cookbooks/testing)

---

**Version**: 2.5.1  
**Last Updated**: December 23, 2025  
**Architecture**: Clean Architecture with Riverpod
