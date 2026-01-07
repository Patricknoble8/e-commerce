# 📁 Complete File Structure

## Project Directory Tree

```
e_commerce/
├── lib/
│   ├── config/
│   │   └── theme/
│   │       ├── colors.dart              # App color palette (backgrounds, foregrounds, borders)
│   │       ├── typography.dart          # Typography scale (headings, body, labels)
│   │       ├── spacing.dart             # 8px grid system & border radius values
│   │       └── theme.dart               # Main theme configuration
│   │
│   ├── models/
│   │   ├── product.dart                 # Product model with pricing & variants
│   │   ├── cart_item.dart               # Cart item with quantity & selection
│   │   └── category.dart                # Product category model
│   │
│   ├── providers/
│   │   └── cart_provider.dart           # Cart state management with Provider
│   │
│   ├── data/
│   │   └── product_data.dart            # Sample product data (4 Nike shoes)
│   │
│   ├── widgets/
│   │   ├── buttons/
│   │   │   └── buttons.dart             # PrimaryButton, SecondaryButton, GhostButton, IconButtonComponent
│   │   │
│   │   ├── cards/
│   │   │   └── cards.dart               # CardComponent, ProductCard
│   │   │
│   │   ├── inputs/
│   │   │   └── inputs.dart              # InputField, SearchField
│   │   │
│   │   └── common/
│   │       └── common_widgets.dart      # Badge, ChipComponent, ColorSelector, SizeSelector, DividerComponent
│   │
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart         # Home screen with product grid, categories, brands
│   │   │
│   │   ├── product_detail/
│   │   │   └── product_detail_screen.dart   # Product details with color/size selection
│   │   │
│   │   └── cart/
│   │       └── cart_screen.dart         # Shopping cart with quantity controls & checkout
│   │
│   └── main.dart                         # App entry point with Provider setup
│
├── assets/                               # (To be added - product images)
│   └── images/
│       ├── nike_air_force.png
│       ├── nike_air_jordan_1.png
│       ├── nike_air_jordan_3.png
│       └── nike_air_force_2.png
│
├── android/                              # Android platform files
├── ios/                                  # iOS platform files
├── linux/                                # Linux platform files
├── macos/                                # macOS platform files
├── web/                                  # Web platform files
├── windows/                              # Windows platform files
│
├── test/
│   └── widget_test.dart                 # Widget tests (to be implemented)
│
├── pubspec.yaml                          # Project dependencies & configuration
├── analysis_options.yaml                 # Dart analysis configuration
├── README.md                             # Project documentation
├── COMPONENTS.md                         # Component catalog & design guide
└── PROJECT_SUMMARY.md                    # Implementation summary
```

---

## 📄 File Descriptions

### Core Application

#### `main.dart` (Entry Point)
```dart
- Sets up MultiProvider with CartProvider
- Configures MaterialApp with AppTheme
- Defines routes (/cart)
- Entry point: HomeScreen
```

---

### Configuration (`config/theme/`)

#### `colors.dart`
```dart
Purpose: Centralized color palette
Contains:
- Background colors (3 shades)
- Foreground/text colors (3 weights)
- Primary colors with hover states
- Border colors
- Ring/focus color
- Status colors (success, error, warning)
- Muted/accent colors
```

#### `typography.dart`
```dart
Purpose: Typography system
Contains:
- Font family constant
- Font weight constants (regular to bold)
- Heading styles (h1-h4)
- Body styles (large, medium, small)
- Label styles (large, medium, small)
- Caption style
```

#### `spacing.dart`
```dart
Purpose: Spacing & sizing constants
Contains:
- Base unit (8px)
- Spacing scale (xs to xxl)
- Padding presets
- Margin presets
- Gap presets
- Border radius values (sm to full)
- Border width values (thin to thick)
```

#### `theme.dart`
```dart
Purpose: Main theme configuration
Contains:
- lightTheme ThemeData
- ColorScheme configuration
- AppBarTheme
- CardTheme
- InputDecorationTheme
- Button themes (Elevated, Outlined, Text)
```

---

### Models (`models/`)

#### `product.dart`
```dart
Model: Product
Fields:
- id, name, price, imageUrl, description
- availableColors, availableSizes, brand, discount
Computed:
- finalPrice (with discount calculation)
- hasDiscount
Methods:
- copyWith()
```

#### `cart_item.dart`
```dart
Model: CartItem
Fields:
- product, quantity, selectedColor, selectedSize
Computed:
- totalPrice
Methods:
- copyWith()
- operator ==
- hashCode
```

#### `category.dart`
```dart
Model: Category
Fields:
- id, name, description
```

---

### State Management (`providers/`)

#### `cart_provider.dart`
```dart
Provider: CartProvider extends ChangeNotifier
State:
- _items (List<CartItem>)
Getters:
- items, itemCount, subtotal, deliveryCharge, total
Methods:
- addToCart(product, color, size)
- removeFromCart(item)
- updateQuantity(item, newQuantity)
- clearCart()
- isInCart(productId)
```

---

### Data (`data/`)

#### `product_data.dart`
```dart
Static Data: ProductData
Contains:
- 4 Nike products (Air Force, Jordan 1, Jordan 3)
- Multiple colors per product
- Size ranges (38-43)
- Prices ($250-$299)
- Detailed descriptions
Methods:
- getProductById(id)
```

---

### Widgets (`widgets/`)

#### `buttons/buttons.dart`
```dart
Components:
1. PrimaryButton
   - Solid dark background
   - White text
   - Loading state
   - Optional icon
   - Full width option

2. SecondaryButton
   - Outlined style
   - 1px border
   - Optional icon
   - Full width option

3. GhostButton
   - Text only
   - No border/background
   - Optional icon

4. IconButtonComponent
   - Icon only
   - Bordered square
   - Custom size
```

#### `cards/cards.dart`
```dart
Components:
1. CardComponent
   - Generic container
   - Border-focused
   - Optional tap handler
   - Customizable padding

2. ProductCard
   - Product image (160px)
   - Favorite toggle button
   - Brand label
   - Product name
   - Price display
   - Tap handler
```

#### `inputs/inputs.dart`
```dart
Components:
1. InputField
   - Optional label
   - Placeholder text
   - Prefix/suffix icons
   - Multi-line support
   - Ring focus state

2. SearchField
   - Search icon prefix
   - Clear button suffix
   - Extends InputField
```

#### `common/common_widgets.dart`
```dart
Components:
1. Badge
   - Pill-shaped
   - Custom colors
   - Text display

2. ChipComponent
   - Selection chip
   - Toggle state
   - Optional icon
   - Bordered

3. ColorSelector
   - Circular (36x36)
   - Colored background
   - Selection indicator
   - Checkmark when selected

4. SizeSelector
   - Square (48x48)
   - Bordered
   - Selection state
   - Centered text

5. DividerComponent
   - Horizontal line
   - 1px height
   - Border color
```

---

### Screens (`screens/`)

#### `home/home_screen.dart`
```dart
Screen: HomeScreen
Features:
- AppBar with menu, search, notifications
- Featured banner with CTA
- Category tabs (5 categories)
- Brand selection (5 brands)
- Product grid (2 columns)
- Favorite toggle per product
- Bottom navigation (4 tabs)

State:
- _selectedCategoryIndex
- _searchQuery
- _favorites (Set<String>)
```

#### `product_detail/product_detail_screen.dart`
```dart
Screen: ProductDetailScreen
Features:
- Large product image (320px)
- 360° view indicator
- Color selection (ColorSelector)
- Size selection (SizeSelector)
- Product description
- Add to cart button
- Order now button
- SnackBar feedback

State:
- _selectedColor
- _selectedSize
- _isFavorite
```

#### `cart/cart_screen.dart`
```dart
Screen: CartScreen
Features:
- Cart items list
- Product images & details
- Quantity controls (+/-)
- Delete item button
- Empty cart state
- Promo code input
- Order summary
- Checkout button

State:
- _promoController (TextEditingController)
```

---

## 📊 File Statistics

### By Category
```
Configuration:  4 files  (~400 lines)
Models:         3 files  (~150 lines)
Providers:      1 file   (~100 lines)
Data:           1 file   (~70 lines)
Components:     4 files  (~800 lines)
Screens:        3 files  (~1,200 lines)
Main:           1 file   (~30 lines)
Documentation:  3 files  (~1,500 lines)
-------------------------------------------
Total:         20 files  (~4,250 lines)
```

### By Type
```
Dart Files:          17 files
Markdown Docs:        3 files
Configuration:        1 file (pubspec.yaml)
-------------------------------------------
Total Project:       21 files
```

---

## 🎯 Import Paths Reference

### Theme Imports
```dart
import 'package:e_commerce/config/theme/colors.dart';
import 'package:e_commerce/config/theme/typography.dart';
import 'package:e_commerce/config/theme/spacing.dart';
import 'package:e_commerce/config/theme/theme.dart';
```

### Model Imports
```dart
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/category.dart';
```

### Provider Imports
```dart
import 'package:e_commerce/providers/cart_provider.dart';
import 'package:provider/provider.dart';
```

### Widget Imports
```dart
import 'package:e_commerce/widgets/buttons/buttons.dart';
import 'package:e_commerce/widgets/cards/cards.dart';
import 'package:e_commerce/widgets/inputs/inputs.dart';
import 'package:e_commerce/widgets/common/common_widgets.dart';
```

### Screen Imports
```dart
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/product_detail/product_detail_screen.dart';
import 'package:e_commerce/screens/cart/cart_screen.dart';
```

---

## 🔍 Quick Navigation

### To Add New Feature:
1. **Model**: Add to `lib/models/`
2. **Provider**: Add to `lib/providers/`
3. **Widget**: Add to `lib/widgets/[category]/`
4. **Screen**: Add to `lib/screens/[feature]/`

### To Customize Theme:
1. **Colors**: Edit `lib/config/theme/colors.dart`
2. **Fonts**: Edit `lib/config/theme/typography.dart`
3. **Spacing**: Edit `lib/config/theme/spacing.dart`
4. **Theme**: Update `lib/config/theme/theme.dart`

### To Add Products:
- Edit `lib/data/product_data.dart`

### To Modify Routes:
- Edit routes in `lib/main.dart`

---

**Structure Type**: Feature-based + Component-based Hybrid  
**Organization**: Clean Architecture Principles  
**Scalability**: ⭐⭐⭐⭐⭐ (Highly scalable)
