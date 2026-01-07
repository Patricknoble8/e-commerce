# Product Images Directory

This directory contains all product images for the e-commerce app.

## Required Images

To display products properly, add the following PNG images (512x512px recommended):

### Nike Collection
- `nike_air_force_1.png`
- `nike_air_max_270.png`
- `nike_dunk_low.png`
- `air_jordan_1.png`
- `nike_react_infinity.png`
- `nike_blazer_mid.png`

### Adidas Collection
- `adidas_ultraboost.png`
- `adidas_stan_smith.png`
- `adidas_nmd_r1.png`
- `adidas_superstar.png`

### Puma Collection
- `puma_suede_classic.png`
- `puma_rsx.png`

### New Balance Collection
- `new_balance_550.png`
- `new_balance_574.png`
- `new_balance_2002r.png`

### Converse Collection
- `converse_chuck_taylor.png`
- `converse_chuck_70.png`

### Vans Collection
- `vans_old_skool.png`
- `vans_authentic.png`
- `vans_sk8_hi.png`

## How to Add Images

### Option 1: Use Real Product Images
1. Download product images from official brand websites or stock photo sites
2. Resize images to 512x512px (square format)
3. Save as PNG with transparent background
4. Name files exactly as listed above

### Option 2: Use Placeholder Images
You can use placeholder services during development:
- https://via.placeholder.com/512
- https://placehold.co/512x512

### Option 3: Use Unsplash API
```dart
// In product_data.dart, replace imageUrl with:
imageUrl: 'https://images.unsplash.com/photo-[your-photo-id]?w=512&h=512&fit=crop'
```

## Image Guidelines

- **Format**: PNG with transparent background preferred
- **Size**: 512x512px (1:1 ratio)
- **Quality**: High resolution for crisp display
- **Background**: White or transparent
- **Angle**: Product shown from side/front view
- **Consistency**: Similar lighting and style across all products

## Current Status

The app will show placeholder icons if images are missing. Add images to this directory and run:

```bash
flutter pub get
flutter run
```

Images will automatically load from this directory.
