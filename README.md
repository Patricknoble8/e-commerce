# 🛍️ E-Commerce Flutter App

A professional e-commerce mobile application built with Flutter, following **shadcn/ui** design principles and clean code architecture.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- 🏠 **Home Screen** - Product grid with categories and brand filters
- 🔍 **Search & Filter** - Find products easily
- 📦 **Product Details** - Detailed view with color and size selection
- 🛒 **Shopping Cart** - Add, remove, and manage cart items
- 💳 **Checkout Flow** - Promo codes and order summary
- ❤️ **Favorites** - Save favorite products
- 🎨 **Professional UI** - shadcn/ui inspired design system

## 🎨 Design Principles

This app follows modern design system standards:

- ✅ **Minimal & Clean** - Border-focused design instead of shadows
- ✅ **Monochrome First** - Neutral colors with subtle accents
- ✅ **Consistent Spacing** - 8px grid system throughout
- ✅ **Accessibility** - WCAG AA compliant contrast ratios
- ✅ **Subtle Interactions** - Ring-based focus states
- ✅ **Professional Typography** - Clear hierarchy and readability

## 🏗️ Architecture

```
lib/
├── config/theme/       # Theme configuration (colors, typography, spacing)
├── models/            # Data models (Product, CartItem, Category)
├── providers/         # State management (CartProvider)
├── data/              # Sample data
├── widgets/           # Reusable UI components
│   ├── buttons/
│   ├── cards/
│   ├── inputs/
│   └── common/
├── screens/           # App screens
│   ├── home/
│   ├── product_detail/
│   └── cart/
└── main.dart
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.5.1   # State management (Riverpod)
  riverpod_annotation: ^2.3.5 # Riverpod annotations
  lucide_icons: ^0.1.0       # Modern icon set

dev_dependencies:
  build_runner: ^2.4.8       # Code generation
  riverpod_generator: ^2.4.0 # Riverpod generator
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd e_commerce
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Screens

### Home Screen
- Product grid layout
- Category tabs (All, Men, Ladies, Sports, Boot)
- Brand selection
- Featured banner with special offers
- Bottom navigation bar

### Product Detail Screen
- Large product image with 360° view indicator
- Color selection with visual indicators
- Size selection with toggle buttons
- Product description
- Add to cart functionality
- Order now option

### Cart Screen
- List of cart items with images
- Quantity controls (+/-)
- Remove item functionality
- Promo code input
- Order summary (subtotal, delivery, total)
- Checkout button

## 🎨 Components

All components are documented in [COMPONENTS.md](COMPONENTS.md)

### Buttons
- `PrimaryButton` - Solid dark background for main actions
- `SecondaryButton` - Outlined style for secondary actions
- `GhostButton` - Text-only for tertiary actions
- `IconButtonComponent` - Icon-only with border

### Cards
- `CardComponent` - Generic card container
- `ProductCard` - Product display in grid

### Inputs
- `InputField` - Text input with label
- `SearchField` - Search-specific input

### Common
- `Badge` - Count or status indicator
- `ChipComponent` - Selection chips
- `ColorSelector` - Color picker
- `SizeSelector` - Size picker
- `DividerComponent` - Visual separator

## 🎯 State Management

Uses **Riverpod** (v2.5.1) for robust, type-safe state management:

### Providers Available:
```dart
// Cart Management
cartProvider                  // Main cart state
cartItemCountProvider         // Total items count
cartSubtotalProvider          // Subtotal amount
cartTotalProvider             // Final total

// Products
productListProvider           // All products
productByIdProvider           // Single product
productsByCategoryProvider    // Filtered products

// Favorites
favoritesProvider             // Favorite products state
favoriteProductsProvider      // List of favorites
```

### Usage:
```dart
// Watch state (rebuilds on change)
final cart = ref.watch(cartProvider);

// Perform actions (no rebuild)
ref.read(cartProvider.notifier).addToCart(product, color, size);

// Computed values
final total = ref.watch(cartTotalProvider);
```

**📖 Full Documentation**: See [RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md) for complete guide.

## 🌈 Theme System

### Colors
- Muted backgrounds (#FFFFFF, #F8F9FA, #F1F3F5)
- Dark slate primary (#0F172A)
- Subtle borders (#E2E8F0)
- Blue ring for focus (#3B82F6)

### Typography
- Font weights: 400 (regular), 500 (medium), 600 (semiBold), 700 (bold)
- Heading scale: 32px, 24px, 20px, 18px
- Body scale: 16px, 14px, 12px

### Spacing
- Based on 8px grid
- Values: 4px, 8px, 16px, 24px, 32px, 48px

## 📝 Code Style

- Clean code principles
- Separation of concerns
- Reusable components
- Type-safe models
- Consistent naming conventions
- Comprehensive documentation

## 🔄 State Flow

```
User Action → Provider Method → State Update → UI Rebuild
```

Example:
```
Tap "Add to Cart" → addToCart() → CartProvider notifies → Cart badge updates
```

## 🎓 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [shadcn/ui](https://ui.shadcn.com/) - Design inspiration
- [Material Design 3](https://m3.material.io/)

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**Note**: This is a demo project showcasing professional Flutter development practices with modern UI/UX design principles.
