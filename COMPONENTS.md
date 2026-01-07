# E-Commerce App - Components Documentation

## Overview
This document provides a comprehensive overview of all UI components used in the e-commerce application, following **shadcn/ui** design principles and clean code architecture.

---

## Table of Contents
1. [Design Principles](#design-principles)
2. [Theme System](#theme-system)
3. [Components](#components)
4. [File Structure](#file-structure)
5. [Summary of Key Improvements](#summary-of-key-improvements)

---

## Design Principles

### shadcn/ui Standard
- **Minimal & Clean**: Border-focused design instead of heavy shadows
- **Monochrome First**: Neutral color palette with subtle accents
- **Accessibility**: High contrast ratios and proper focus states
- **Consistency**: 8px spacing grid throughout the app
- **Subtle Interactions**: Ring-based focus states and gentle hover effects

---

## Theme System

### Colors (`lib/config/theme/colors.dart`)
```dart
- Background Colors:
  - background: #FFFFFF
  - backgroundSecondary: #F8F9FA
  - backgroundMuted: #F1F3F5

- Foreground/Text Colors:
  - foreground: #0F172A (primary text)
  - foregroundSecondary: #475569 (secondary text)
  - foregroundMuted: #94A3B8 (muted text)

- Primary Colors:
  - primary: #0F172A (dark slate)
  - primaryHover: #1E293B
  - primaryForeground: #FFFFFF

- Border Colors:
  - border: #E2E8F0
  - borderHover: #CBD5E1

- Ring/Focus:
  - ring: #3B82F6 (focus indicator)

- Status Colors:
  - success: #10B981
  - error: #EF4444
  - warning: #F59E0B
```

### Typography (`lib/config/theme/typography.dart`)
```dart
Font Weights:
- regular: 400
- medium: 500
- semiBold: 600
- bold: 700

Heading Styles:
- h1: 32px, bold
- h2: 24px, semiBold
- h3: 20px, semiBold
- h4: 18px, semiBold

Body Styles:
- bodyLarge: 16px, regular
- bodyMedium: 14px, regular
- bodySmall: 12px, regular

Label Styles:
- labelLarge: 14px, medium
- labelMedium: 12px, medium
- labelSmall: 11px, medium
```

### Spacing (`lib/config/theme/spacing.dart`)
```dart
Based on 8px grid:
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- xxl: 48px

Border Radius:
- sm: 4px
- md: 6px
- lg: 8px
- xl: 12px
- full: 9999px

Border Width:
- thin: 1px
- medium: 1.5px
- thick: 2px
```

---

## Components

### 1. Buttons (`lib/widgets/buttons/buttons.dart`)

#### PrimaryButton
**Purpose**: Main call-to-action button with solid background
**Design**: 
- Solid dark background (#0F172A)
- White text
- No elevation/shadows
- Subtle hover overlay
- Loading state support
- Optional icon

**Usage**:
```dart
PrimaryButton(
  text: 'Add to cart',
  onPressed: () {},
  icon: Icons.shopping_cart,
  fullWidth: true,
  isLoading: false,
)
```

#### SecondaryButton
**Purpose**: Secondary actions with outlined style
**Design**:
- Transparent background
- 1px border (#E2E8F0)
- Dark text
- Subtle hover state

**Usage**:
```dart
SecondaryButton(
  text: 'Order Now',
  onPressed: () {},
  icon: Icons.shopping_bag_outlined,
)
```

#### GhostButton
**Purpose**: Tertiary actions with minimal styling
**Design**:
- No background
- No border
- Text only with hover state

**Usage**:
```dart
GhostButton(
  text: 'See all',
  onPressed: () {},
)
```

#### IconButtonComponent
**Purpose**: Icon-only button with border
**Design**:
- Square shape with border
- Transparent or custom background
- Consistent 40x40 size

**Usage**:
```dart
IconButtonComponent(
  icon: Icons.favorite_border,
  onPressed: () {},
)
```

---

### 2. Cards (`lib/widgets/cards/cards.dart`)

#### CardComponent
**Purpose**: Generic card container
**Design**:
- Border-focused (1px solid border)
- No shadows
- 8px border radius
- Subtle hover on tap

**Usage**:
```dart
CardComponent(
  child: YourWidget(),
  onTap: () {},
  padding: EdgeInsets.all(16),
)
```

#### ProductCard
**Purpose**: Display product in grid view
**Design**:
- Image container with muted background
- Favorite button overlay
- Product name, brand, and price
- Border-focused design
- 160px image height

**Features**:
- Favorite toggle
- Product tap handler
- Error handling for images
- Text overflow management

**Usage**:
```dart
ProductCard(
  imageUrl: 'assets/images/product.png',
  name: 'Nike Air Force',
  price: '\$250',
  brand: 'Nike',
  isFavorite: false,
  onTap: () {},
  onFavoriteToggle: () {},
)
```

---

### 3. Inputs (`lib/widgets/inputs/inputs.dart`)

#### InputField
**Purpose**: Text input with label
**Design**:
- 1px border in default state
- 2px blue ring on focus (#3B82F6)
- White background
- Proper padding (12px horizontal, 8px vertical)

**Features**:
- Optional label
- Placeholder text
- Prefix/suffix icons
- Multi-line support

**Usage**:
```dart
InputField(
  label: 'Email',
  placeholder: 'Enter your email',
  onChanged: (value) {},
  prefixIcon: Icon(Icons.email),
)
```

#### SearchField
**Purpose**: Search-specific input field
**Design**:
- Search icon prefix
- Clear button suffix
- Same styling as InputField

**Usage**:
```dart
SearchField(
  placeholder: 'Search products...',
  onChanged: (query) {},
  onClear: () {},
)
```

---

### 4. Common Widgets (`lib/widgets/common/common_widgets.dart`)

#### Badge
**Purpose**: Display count or status
**Design**:
- Small pill-shaped container
- Solid background
- White text
- Full border radius

**Usage**:
```dart
Badge(
  text: '3',
  backgroundColor: AppColors.primary,
)
```

#### ChipComponent
**Purpose**: Selection chips for filters
**Design**:
- Bordered container
- Toggleable selected state
- Solid background when selected

**Usage**:
```dart
ChipComponent(
  label: 'Men',
  isSelected: true,
  onTap: () {},
  icon: Icons.male,
)
```

#### ColorSelector
**Purpose**: Color selection for products
**Design**:
- Circular container (36x36)
- Colored background
- Border indicates selection
- Checkmark when selected

**Usage**:
```dart
ColorSelector(
  color: Colors.blue,
  isSelected: true,
  onTap: () {},
)
```

#### SizeSelector
**Purpose**: Size selection for products
**Design**:
- Square button (48x48)
- Bordered container
- Solid background when selected
- Centered text

**Usage**:
```dart
SizeSelector(
  size: '42',
  isSelected: true,
  onTap: () {},
)
```

#### DividerComponent
**Purpose**: Visual separator
**Design**:
- 1px height
- Border color (#E2E8F0)

**Usage**:
```dart
DividerComponent()
```

---

## File Structure

```
lib/
├── config/
│   └── theme/
│       ├── colors.dart           # Color system
│       ├── typography.dart       # Typography scale
│       ├── spacing.dart          # Spacing & radius
│       └── theme.dart            # Main theme config
│
├── models/
│   ├── product.dart              # Product data model
│   ├── cart_item.dart            # Cart item model
│   └── category.dart             # Category model
│
├── providers/
│   └── cart_provider.dart        # Cart state management
│
├── data/
│   └── product_data.dart         # Sample product data
│
├── widgets/
│   ├── buttons/
│   │   └── buttons.dart          # All button components
│   ├── cards/
│   │   └── cards.dart            # Card components
│   ├── inputs/
│   │   └── inputs.dart           # Input components
│   └── common/
│       └── common_widgets.dart   # Common UI elements
│
├── screens/
│   ├── home/
│   │   └── home_screen.dart      # Home/Product listing
│   ├── product_detail/
│   │   └── product_detail_screen.dart  # Product details
│   └── cart/
│       └── cart_screen.dart      # Shopping cart
│
└── main.dart                     # App entry point
```

---

## Summary of Key Improvements for shadcn/ui Professional Standard

### ✅ Visual Design
- ✓ **Replaced gradients** with solid, muted backgrounds
- ✓ **Used subtle borders** (1px) instead of heavy shadows (elevation: 0)
- ✓ **Consistent 8px spacing grid** throughout all components
- ✓ **Better contrast** with proper foreground/background color ratios
- ✓ **Accessibility compliance** with WCAG AA standards

### ✅ Typography
- ✓ **Clear hierarchy** with H1 (32px) → H4 (18px)
- ✓ **Consistent font weights** (400-700 range only)
- ✓ **Proper text sizing scale** with line heights (1.2-1.6)
- ✓ **Better spacing** with letter-spacing on large headings

### ✅ Components
**Buttons:**
- ✓ Solid primary (dark background)
- ✓ Outlined secondary (1px border)
- ✓ Ghost for tertiary actions
- ✓ Subtle hover states (no heavy shadows)

**Cards:**
- ✓ Minimal shadows (elevation: 0)
- ✓ More padding (16px default)
- ✓ Border-focused design (1px borders)
- ✓ Consistent 8px border radius

**Inputs:**
- ✓ Bordered style (1px default)
- ✓ Ring focus states (2px blue ring)
- ✓ Proper padding and sizing
- ✓ Clear placeholder styling

**Icons:**
- ✓ Monochrome color scheme
- ✓ Consistent sizing (18-24px)
- ✓ Lucide-style design language

### ✅ Interaction
- ✓ **Subtle animations** (no heavy transitions)
- ✓ **Ring-based selection** indicators for focus states
- ✓ **Ghost buttons** for secondary actions
- ✓ **Better active/focus** states with proper contrast
- ✓ **Hover overlays** instead of shadows

### ✅ Color System
- ✓ **Consistent palette** (primary, secondary, muted, accent)
- ✓ **Removed bold colored** elements (no bright gradients)
- ✓ **More neutral** professional look with slate grays
- ✓ **Proper color naming** (foreground, background, muted)
- ✓ **Status colors** for success, error, warning

### ✅ Architecture
- ✓ **Clean separation** of concerns (models, views, providers)
- ✓ **Reusable components** with consistent API
- ✓ **Type-safe models** with proper data structures
- ✓ **State management** with Provider pattern
- ✓ **Scalable file structure** for team collaboration

---

## Bottom Line

The app has been completely transformed from a **colorful, gradient-heavy, shadow-based design** to a **minimal, border-focused, monochrome design** with:

1. **Subtle interactions** - No flashy animations, just gentle hover states
2. **Proper spacing** - Consistent 8px grid system
3. **Professional typography** - Clear hierarchy and readability
4. **Accessible colors** - High contrast, WCAG compliant
5. **Clean architecture** - Well-organized, maintainable code
6. **Reusable components** - DRY principle throughout

This matches modern design systems like **shadcn/ui**, **Radix UI**, and **Tailwind UI** - focusing on simplicity, consistency, and professional aesthetics.

---

## Usage Examples

### Creating a new screen:
```dart
import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Title', style: AppTypography.h4),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            PrimaryButton(
              text: 'Action',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

### Adding a new color:
Edit `lib/config/theme/colors.dart` and add to the color palette following the naming convention (background, foreground, primary, etc.).

### Creating a new component:
1. Create file in appropriate `widgets/` subfolder
2. Follow shadcn/ui design principles
3. Use theme constants (AppColors, AppSpacing, AppTypography)
4. Export from the folder's main file

---

**Version**: 1.0.0  
**Last Updated**: December 23, 2025  
**Framework**: Flutter 3.10+  
**Design System**: shadcn/ui inspired
