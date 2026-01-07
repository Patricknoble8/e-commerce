import '../models/category.dart';

/// Complete category hierarchy for e-commerce platform
/// Professional structure with 20 main categories and detailed subcategories
class CategoryData {
  CategoryData._();

  /// All main categories with their subcategories
  static const List<Category> categories = [
    // 1. Fashion & Apparel
    Category(
      id: 'fashion',
      name: 'Fashion & Apparel',
      emoji: '👔',
      displayOrder: 1,
      subcategories: [
        Category(
          id: 'mens-clothing',
          name: "Men's Clothing",
          parentId: 'fashion',
          subcategories: [
            Category(
              id: 'mens-shirts',
              name: 'Shirts, T-shirts, Polo',
              parentId: 'mens-clothing',
            ),
            Category(
              id: 'mens-pants',
              name: 'Pants, Jeans, Shorts',
              parentId: 'mens-clothing',
            ),
            Category(
              id: 'mens-suits',
              name: 'Suits, Blazers',
              parentId: 'mens-clothing',
            ),
            Category(
              id: 'mens-activewear',
              name: 'Activewear, Sportswear',
              parentId: 'mens-clothing',
            ),
            Category(
              id: 'mens-underwear',
              name: 'Underwear, Sleepwear',
              parentId: 'mens-clothing',
            ),
            Category(
              id: 'mens-outerwear',
              name: 'Outerwear (Jackets, Coats)',
              parentId: 'mens-clothing',
            ),
          ],
        ),
        Category(
          id: 'womens-clothing',
          name: "Women's Clothing",
          parentId: 'fashion',
          subcategories: [
            Category(
              id: 'womens-dresses',
              name: 'Dresses, Skirts',
              parentId: 'womens-clothing',
            ),
            Category(
              id: 'womens-tops',
              name: 'Tops, Blouses, T-shirts',
              parentId: 'womens-clothing',
            ),
            Category(
              id: 'womens-pants',
              name: 'Pants, Jeans, Leggings',
              parentId: 'womens-clothing',
            ),
            Category(
              id: 'womens-activewear',
              name: 'Activewear, Yoga Wear',
              parentId: 'womens-clothing',
            ),
            Category(
              id: 'womens-lingerie',
              name: 'Lingerie, Sleepwear',
              parentId: 'womens-clothing',
            ),
            Category(
              id: 'womens-outerwear',
              name: 'Outerwear, Coats',
              parentId: 'womens-clothing',
            ),
          ],
        ),
        Category(
          id: 'kids-baby-fashion',
          name: 'Kids & Baby',
          parentId: 'fashion',
          subcategories: [
            Category(
              id: 'boys-clothing',
              name: 'Boys Clothing',
              parentId: 'kids-baby-fashion',
            ),
            Category(
              id: 'girls-clothing',
              name: 'Girls Clothing',
              parentId: 'kids-baby-fashion',
            ),
            Category(
              id: 'baby-clothing',
              name: 'Baby Clothing (0-2 years)',
              parentId: 'kids-baby-fashion',
            ),
            Category(
              id: 'school-uniforms',
              name: 'School Uniforms',
              parentId: 'kids-baby-fashion',
            ),
          ],
        ),
      ],
    ),

    // 2. Footwear
    Category(
      id: 'footwear',
      name: 'Footwear',
      emoji: '👟',
      displayOrder: 2,
      subcategories: [
        Category(
          id: 'sneakers',
          name: 'Sneakers & Athletic Shoes',
          parentId: 'footwear',
        ),
        Category(
          id: 'casual-shoes',
          name: 'Casual Shoes',
          parentId: 'footwear',
        ),
        Category(
          id: 'formal-shoes',
          name: 'Formal Shoes',
          parentId: 'footwear',
        ),
        Category(
          id: 'boots',
          name: 'Boots (Winter, Chelsea, Combat)',
          parentId: 'footwear',
        ),
        Category(
          id: 'sandals',
          name: 'Sandals & Flip-flops',
          parentId: 'footwear',
        ),
        Category(id: 'slippers', name: 'Slippers', parentId: 'footwear'),
        Category(id: 'heels', name: 'Heels & Pumps', parentId: 'footwear'),
        Category(id: 'flats', name: 'Flats & Loafers', parentId: 'footwear'),
      ],
    ),

    // 3. Accessories
    Category(
      id: 'accessories',
      name: 'Accessories',
      emoji: '👜',
      displayOrder: 3,
      subcategories: [
        Category(
          id: 'bags-luggage',
          name: 'Bags & Luggage',
          parentId: 'accessories',
          subcategories: [
            Category(
              id: 'handbags',
              name: 'Handbags, Purses',
              parentId: 'bags-luggage',
            ),
            Category(
              id: 'backpacks',
              name: 'Backpacks',
              parentId: 'bags-luggage',
            ),
            Category(id: 'wallets', name: 'Wallets', parentId: 'bags-luggage'),
            Category(
              id: 'travel-luggage',
              name: 'Travel Luggage',
              parentId: 'bags-luggage',
            ),
            Category(
              id: 'laptop-bags',
              name: 'Laptop Bags',
              parentId: 'bags-luggage',
            ),
          ],
        ),
        Category(
          id: 'jewelry-acc',
          name: 'Jewelry',
          parentId: 'accessories',
          subcategories: [
            Category(
              id: 'necklaces-earrings',
              name: 'Necklaces, Earrings',
              parentId: 'jewelry-acc',
            ),
            Category(
              id: 'rings-bracelets',
              name: 'Rings, Bracelets',
              parentId: 'jewelry-acc',
            ),
            Category(
              id: 'watches-acc',
              name: 'Watches',
              parentId: 'jewelry-acc',
            ),
          ],
        ),
        Category(
          id: 'other-accessories',
          name: 'Other Accessories',
          parentId: 'accessories',
          subcategories: [
            Category(
              id: 'sunglasses',
              name: 'Sunglasses, Eyewear',
              parentId: 'other-accessories',
            ),
            Category(id: 'belts', name: 'Belts', parentId: 'other-accessories'),
            Category(
              id: 'hats-caps',
              name: 'Hats, Caps',
              parentId: 'other-accessories',
            ),
            Category(
              id: 'scarves-gloves',
              name: 'Scarves, Gloves',
              parentId: 'other-accessories',
            ),
            Category(
              id: 'phone-cases',
              name: 'Phone Cases',
              parentId: 'other-accessories',
            ),
          ],
        ),
      ],
    ),

    // 4. Electronics
    Category(
      id: 'electronics',
      name: 'Electronics',
      emoji: '📱',
      displayOrder: 4,
      subcategories: [
        Category(
          id: 'mobile-tablets',
          name: 'Mobile & Tablets',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'smartphones',
              name: 'Smartphones',
              parentId: 'mobile-tablets',
            ),
            Category(
              id: 'tablets',
              name: 'Tablets',
              parentId: 'mobile-tablets',
            ),
            Category(
              id: 'phone-accessories',
              name: 'Phone Accessories (Cases, Chargers)',
              parentId: 'mobile-tablets',
            ),
          ],
        ),
        Category(
          id: 'computers-laptops',
          name: 'Computers & Laptops',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'laptops-desktops',
              name: 'Laptops, Desktops',
              parentId: 'computers-laptops',
            ),
            Category(
              id: 'monitors',
              name: 'Monitors',
              parentId: 'computers-laptops',
            ),
            Category(
              id: 'keyboards-mice',
              name: 'Keyboards, Mice',
              parentId: 'computers-laptops',
            ),
            Category(
              id: 'storage-drives',
              name: 'Storage Drives',
              parentId: 'computers-laptops',
            ),
            Category(
              id: 'computer-accessories',
              name: 'Computer Accessories',
              parentId: 'computers-laptops',
            ),
          ],
        ),
        Category(
          id: 'audio',
          name: 'Audio',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'headphones-earbuds',
              name: 'Headphones, Earbuds',
              parentId: 'audio',
            ),
            Category(
              id: 'speakers',
              name: 'Speakers (Bluetooth, Home)',
              parentId: 'audio',
            ),
            Category(id: 'soundbars', name: 'Soundbars', parentId: 'audio'),
            Category(id: 'microphones', name: 'Microphones', parentId: 'audio'),
          ],
        ),
        Category(
          id: 'cameras',
          name: 'Cameras & Photography',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'dslr-mirrorless',
              name: 'DSLR, Mirrorless Cameras',
              parentId: 'cameras',
            ),
            Category(id: 'lenses', name: 'Lenses', parentId: 'cameras'),
            Category(
              id: 'tripods',
              name: 'Tripods, Accessories',
              parentId: 'cameras',
            ),
            Category(
              id: 'action-cameras',
              name: 'Action Cameras',
              parentId: 'cameras',
            ),
          ],
        ),
        Category(
          id: 'wearable-tech',
          name: 'Wearable Technology',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'smartwatches',
              name: 'Smartwatches',
              parentId: 'wearable-tech',
            ),
            Category(
              id: 'fitness-trackers',
              name: 'Fitness Trackers',
              parentId: 'wearable-tech',
            ),
            Category(
              id: 'vr-headsets',
              name: 'VR Headsets',
              parentId: 'wearable-tech',
            ),
          ],
        ),
        Category(
          id: 'gaming',
          name: 'Gaming',
          parentId: 'electronics',
          subcategories: [
            Category(
              id: 'consoles',
              name: 'Consoles (PlayStation, Xbox, Nintendo)',
              parentId: 'gaming',
            ),
            Category(id: 'gaming-pcs', name: 'Gaming PCs', parentId: 'gaming'),
            Category(
              id: 'controllers',
              name: 'Controllers',
              parentId: 'gaming',
            ),
            Category(
              id: 'gaming-headsets',
              name: 'Gaming Headsets',
              parentId: 'gaming',
            ),
            Category(
              id: 'video-games',
              name: 'Video Games',
              parentId: 'gaming',
            ),
          ],
        ),
      ],
    ),

    // 5. Home & Living
    Category(
      id: 'home-living',
      name: 'Home & Living',
      emoji: '🏠',
      displayOrder: 5,
      subcategories: [
        Category(
          id: 'furniture',
          name: 'Furniture',
          parentId: 'home-living',
          subcategories: [
            Category(
              id: 'living-room-furniture',
              name: 'Living Room (Sofas, Tables)',
              parentId: 'furniture',
            ),
            Category(
              id: 'bedroom-furniture',
              name: 'Bedroom (Beds, Wardrobes)',
              parentId: 'furniture',
            ),
            Category(
              id: 'office-furniture',
              name: 'Office Furniture',
              parentId: 'furniture',
            ),
            Category(
              id: 'outdoor-furniture',
              name: 'Outdoor Furniture',
              parentId: 'furniture',
            ),
          ],
        ),
        Category(
          id: 'home-decor',
          name: 'Home Decor',
          parentId: 'home-living',
          subcategories: [
            Category(
              id: 'wall-art',
              name: 'Wall Art, Paintings',
              parentId: 'home-decor',
            ),
            Category(
              id: 'cushions-throws',
              name: 'Cushions, Throws',
              parentId: 'home-decor',
            ),
            Category(
              id: 'rugs-carpets',
              name: 'Rugs, Carpets',
              parentId: 'home-decor',
            ),
            Category(
              id: 'curtains-blinds',
              name: 'Curtains, Blinds',
              parentId: 'home-decor',
            ),
            Category(
              id: 'lighting',
              name: 'Lighting (Lamps, Chandeliers)',
              parentId: 'home-decor',
            ),
            Category(
              id: 'plants-planters',
              name: 'Plants, Planters',
              parentId: 'home-decor',
            ),
          ],
        ),
        Category(
          id: 'kitchen-dining',
          name: 'Kitchen & Dining',
          parentId: 'home-living',
          subcategories: [
            Category(
              id: 'cookware',
              name: 'Cookware, Utensils',
              parentId: 'kitchen-dining',
            ),
            Category(
              id: 'dinnerware',
              name: 'Dinnerware, Glassware',
              parentId: 'kitchen-dining',
            ),
            Category(
              id: 'small-appliances',
              name: 'Small Appliances (Blenders, Toasters)',
              parentId: 'kitchen-dining',
            ),
            Category(
              id: 'storage-containers',
              name: 'Storage Containers',
              parentId: 'kitchen-dining',
            ),
          ],
        ),
        Category(
          id: 'bedding-bath',
          name: 'Bedding & Bath',
          parentId: 'home-living',
          subcategories: [
            Category(
              id: 'bed-sheets',
              name: 'Bed Sheets, Comforters',
              parentId: 'bedding-bath',
            ),
            Category(
              id: 'pillows-mattresses',
              name: 'Pillows, Mattresses',
              parentId: 'bedding-bath',
            ),
            Category(id: 'towels', name: 'Towels', parentId: 'bedding-bath'),
            Category(
              id: 'bath-accessories',
              name: 'Bath Accessories',
              parentId: 'bedding-bath',
            ),
          ],
        ),
      ],
    ),

    // 6. Beauty & Personal Care
    Category(
      id: 'beauty',
      name: 'Beauty & Personal Care',
      emoji: '💄',
      displayOrder: 6,
      subcategories: [
        Category(
          id: 'makeup',
          name: 'Makeup',
          parentId: 'beauty',
          subcategories: [
            Category(
              id: 'face-makeup',
              name: 'Face (Foundation, Concealer)',
              parentId: 'makeup',
            ),
            Category(
              id: 'eye-makeup',
              name: 'Eyes (Mascara, Eyeshadow)',
              parentId: 'makeup',
            ),
            Category(
              id: 'lip-makeup',
              name: 'Lips (Lipstick, Gloss)',
              parentId: 'makeup',
            ),
            Category(id: 'nail-makeup', name: 'Nails', parentId: 'makeup'),
          ],
        ),
        Category(
          id: 'skincare',
          name: 'Skincare',
          parentId: 'beauty',
          subcategories: [
            Category(
              id: 'cleansers-toners',
              name: 'Cleansers, Toners',
              parentId: 'skincare',
            ),
            Category(
              id: 'moisturizers-serums',
              name: 'Moisturizers, Serums',
              parentId: 'skincare',
            ),
            Category(id: 'sunscreen', name: 'Sunscreen', parentId: 'skincare'),
            Category(
              id: 'face-masks',
              name: 'Face Masks',
              parentId: 'skincare',
            ),
            Category(
              id: 'anti-aging',
              name: 'Anti-aging Products',
              parentId: 'skincare',
            ),
          ],
        ),
        Category(
          id: 'haircare',
          name: 'Hair Care',
          parentId: 'beauty',
          subcategories: [
            Category(
              id: 'shampoo-conditioner',
              name: 'Shampoo, Conditioner',
              parentId: 'haircare',
            ),
            Category(
              id: 'hair-styling-tools',
              name: 'Hair Styling Tools',
              parentId: 'haircare',
            ),
            Category(
              id: 'hair-color',
              name: 'Hair Color',
              parentId: 'haircare',
            ),
            Category(
              id: 'hair-accessories',
              name: 'Hair Accessories',
              parentId: 'haircare',
            ),
          ],
        ),
        Category(
          id: 'fragrance',
          name: 'Fragrance',
          parentId: 'beauty',
          subcategories: [
            Category(id: 'perfumes', name: 'Perfumes', parentId: 'fragrance'),
            Category(id: 'colognes', name: 'Colognes', parentId: 'fragrance'),
            Category(
              id: 'body-sprays',
              name: 'Body Sprays',
              parentId: 'fragrance',
            ),
          ],
        ),
        Category(
          id: 'personal-care',
          name: 'Personal Care',
          parentId: 'beauty',
          subcategories: [
            Category(
              id: 'oral-care',
              name: 'Oral Care',
              parentId: 'personal-care',
            ),
            Category(
              id: 'shaving-grooming',
              name: 'Shaving & Grooming',
              parentId: 'personal-care',
            ),
            Category(
              id: 'bath-body',
              name: 'Bath & Body',
              parentId: 'personal-care',
            ),
          ],
        ),
      ],
    ),

    // 7. Health & Wellness
    Category(
      id: 'health-wellness',
      name: 'Health & Wellness',
      emoji: '💪',
      displayOrder: 7,
      subcategories: [
        Category(
          id: 'vitamins-supplements',
          name: 'Vitamins & Supplements',
          parentId: 'health-wellness',
          subcategories: [
            Category(
              id: 'multivitamins',
              name: 'Multivitamins',
              parentId: 'vitamins-supplements',
            ),
            Category(
              id: 'protein-powder',
              name: 'Protein Powder',
              parentId: 'vitamins-supplements',
            ),
            Category(
              id: 'omega-fishoil',
              name: 'Omega-3, Fish Oil',
              parentId: 'vitamins-supplements',
            ),
            Category(
              id: 'probiotics',
              name: 'Probiotics',
              parentId: 'vitamins-supplements',
            ),
          ],
        ),
        Category(
          id: 'fitness-equipment',
          name: 'Fitness Equipment',
          parentId: 'health-wellness',
          subcategories: [
            Category(
              id: 'yoga-mats',
              name: 'Yoga Mats',
              parentId: 'fitness-equipment',
            ),
            Category(
              id: 'dumbbells-bands',
              name: 'Dumbbells, Resistance Bands',
              parentId: 'fitness-equipment',
            ),
            Category(
              id: 'cardio-machines',
              name: 'Treadmills, Exercise Bikes',
              parentId: 'fitness-equipment',
            ),
            Category(
              id: 'fitness-trackers-eq',
              name: 'Fitness Trackers',
              parentId: 'fitness-equipment',
            ),
          ],
        ),
        Category(
          id: 'medical-supplies',
          name: 'Medical Supplies',
          parentId: 'health-wellness',
          subcategories: [
            Category(
              id: 'first-aid',
              name: 'First Aid',
              parentId: 'medical-supplies',
            ),
            Category(
              id: 'bp-monitors',
              name: 'Blood Pressure Monitors',
              parentId: 'medical-supplies',
            ),
            Category(
              id: 'thermometers',
              name: 'Thermometers',
              parentId: 'medical-supplies',
            ),
          ],
        ),
      ],
    ),

    // 8. Sports & Outdoors
    Category(
      id: 'sports-outdoors',
      name: 'Sports & Outdoors',
      emoji: '⚽',
      displayOrder: 8,
      subcategories: [
        Category(
          id: 'sports-equipment',
          name: 'Sports Equipment',
          parentId: 'sports-outdoors',
          subcategories: [
            Category(
              id: 'gym-equipment',
              name: 'Gym Equipment',
              parentId: 'sports-equipment',
            ),
            Category(
              id: 'cycling',
              name: 'Cycling (Bikes, Helmets)',
              parentId: 'sports-equipment',
            ),
            Category(
              id: 'running-gear',
              name: 'Running Gear',
              parentId: 'sports-equipment',
            ),
            Category(
              id: 'team-sports',
              name: 'Team Sports (Football, Basketball)',
              parentId: 'sports-equipment',
            ),
            Category(
              id: 'racquet-sports',
              name: 'Racquet Sports (Tennis, Badminton)',
              parentId: 'sports-equipment',
            ),
          ],
        ),
        Category(
          id: 'outdoor-recreation',
          name: 'Outdoor Recreation',
          parentId: 'sports-outdoors',
          subcategories: [
            Category(
              id: 'camping-hiking',
              name: 'Camping & Hiking',
              parentId: 'outdoor-recreation',
            ),
            Category(
              id: 'fishing',
              name: 'Fishing',
              parentId: 'outdoor-recreation',
            ),
            Category(
              id: 'swimming',
              name: 'Swimming',
              parentId: 'outdoor-recreation',
            ),
            Category(
              id: 'climbing',
              name: 'Climbing',
              parentId: 'outdoor-recreation',
            ),
          ],
        ),
        Category(
          id: 'activewear-sports',
          name: 'Activewear',
          parentId: 'sports-outdoors',
          subcategories: [
            Category(
              id: 'sports-clothing',
              name: 'Sports Clothing',
              parentId: 'activewear-sports',
            ),
            Category(
              id: 'athletic-shoes',
              name: 'Athletic Shoes',
              parentId: 'activewear-sports',
            ),
            Category(
              id: 'sports-accessories',
              name: 'Sports Accessories',
              parentId: 'activewear-sports',
            ),
          ],
        ),
      ],
    ),

    // 9. Toys & Games
    Category(
      id: 'toys-games',
      name: 'Toys & Games',
      emoji: '🎮',
      displayOrder: 9,
      subcategories: [
        Category(
          id: 'kids-toys',
          name: 'Kids Toys',
          parentId: 'toys-games',
          subcategories: [
            Category(
              id: 'action-figures',
              name: 'Action Figures',
              parentId: 'kids-toys',
            ),
            Category(
              id: 'dolls',
              name: 'Dolls & Dollhouses',
              parentId: 'kids-toys',
            ),
            Category(
              id: 'building-blocks',
              name: 'Building Blocks (LEGO)',
              parentId: 'kids-toys',
            ),
            Category(
              id: 'educational-toys',
              name: 'Educational Toys',
              parentId: 'kids-toys',
            ),
            Category(
              id: 'rc-toys',
              name: 'Remote Control Toys',
              parentId: 'kids-toys',
            ),
          ],
        ),
        Category(
          id: 'games',
          name: 'Games',
          parentId: 'toys-games',
          subcategories: [
            Category(id: 'board-games', name: 'Board Games', parentId: 'games'),
            Category(id: 'puzzles', name: 'Puzzles', parentId: 'games'),
            Category(id: 'card-games', name: 'Card Games', parentId: 'games'),
            Category(
              id: 'outdoor-play',
              name: 'Outdoor Play',
              parentId: 'games',
            ),
          ],
        ),
      ],
    ),

    // 10. Books & Media
    Category(
      id: 'books-media',
      name: 'Books & Media',
      emoji: '📚',
      displayOrder: 10,
      subcategories: [
        Category(
          id: 'books',
          name: 'Books (Fiction, Non-fiction, Educational)',
          parentId: 'books-media',
        ),
        Category(id: 'ebooks', name: 'E-books', parentId: 'books-media'),
        Category(id: 'audiobooks', name: 'Audiobooks', parentId: 'books-media'),
        Category(id: 'magazines', name: 'Magazines', parentId: 'books-media'),
        Category(
          id: 'music',
          name: 'Music (Vinyl, CDs)',
          parentId: 'books-media',
        ),
        Category(
          id: 'movies-tv',
          name: 'Movies & TV Shows (Blu-ray, DVD)',
          parentId: 'books-media',
        ),
      ],
    ),

    // 11. Baby & Kids
    Category(
      id: 'baby-kids',
      name: 'Baby & Kids',
      emoji: '👶',
      displayOrder: 11,
      subcategories: [
        Category(
          id: 'baby-clothing-main',
          name: 'Baby Clothing',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'baby-feeding',
          name: 'Baby Feeding (Bottles, Bibs)',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'diapers-wipes',
          name: 'Diapers & Wipes',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'baby-care',
          name: 'Baby Care Products',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'nursery-furniture',
          name: 'Nursery Furniture',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'strollers-carseats',
          name: 'Strollers, Car Seats',
          parentId: 'baby-kids',
        ),
        Category(
          id: 'baby-toys',
          name: 'Toys (0-3 years)',
          parentId: 'baby-kids',
        ),
      ],
    ),

    // 12. Automotive
    Category(
      id: 'automotive',
      name: 'Automotive',
      emoji: '🚗',
      displayOrder: 12,
      subcategories: [
        Category(
          id: 'car-accessories',
          name: 'Car Accessories',
          parentId: 'automotive',
        ),
        Category(
          id: 'car-electronics',
          name: 'Car Electronics (Dash Cams, GPS)',
          parentId: 'automotive',
        ),
        Category(
          id: 'car-care',
          name: 'Car Care Products',
          parentId: 'automotive',
        ),
        Category(
          id: 'tires-wheels',
          name: 'Tires & Wheels',
          parentId: 'automotive',
        ),
        Category(
          id: 'motorcycle-accessories',
          name: 'Motorcycle Accessories',
          parentId: 'automotive',
        ),
        Category(
          id: 'auto-tools',
          name: 'Tools & Equipment',
          parentId: 'automotive',
        ),
      ],
    ),

    // 13. Pet Supplies
    Category(
      id: 'pet-supplies',
      name: 'Pet Supplies',
      emoji: '🐾',
      displayOrder: 13,
      subcategories: [
        Category(
          id: 'pet-food',
          name: 'Pet Food (Dogs, Cats, Birds)',
          parentId: 'pet-supplies',
        ),
        Category(id: 'pet-toys', name: 'Pet Toys', parentId: 'pet-supplies'),
        Category(
          id: 'pet-accessories',
          name: 'Pet Accessories (Collars, Leashes)',
          parentId: 'pet-supplies',
        ),
        Category(
          id: 'pet-grooming',
          name: 'Pet Grooming',
          parentId: 'pet-supplies',
        ),
        Category(
          id: 'pet-healthcare',
          name: 'Pet Healthcare',
          parentId: 'pet-supplies',
        ),
        Category(
          id: 'aquarium-supplies',
          name: 'Aquarium Supplies',
          parentId: 'pet-supplies',
        ),
      ],
    ),

    // 14. Grocery & Food
    Category(
      id: 'grocery-food',
      name: 'Grocery & Food',
      emoji: '🛒',
      displayOrder: 14,
      subcategories: [
        Category(
          id: 'fresh-produce',
          name: 'Fresh Produce',
          parentId: 'grocery-food',
        ),
        Category(
          id: 'dairy-eggs',
          name: 'Dairy & Eggs',
          parentId: 'grocery-food',
        ),
        Category(
          id: 'meat-seafood',
          name: 'Meat & Seafood',
          parentId: 'grocery-food',
        ),
        Category(id: 'bakery', name: 'Bakery', parentId: 'grocery-food'),
        Category(id: 'beverages', name: 'Beverages', parentId: 'grocery-food'),
        Category(
          id: 'snacks-candy',
          name: 'Snacks & Candy',
          parentId: 'grocery-food',
        ),
        Category(
          id: 'pantry-staples',
          name: 'Pantry Staples',
          parentId: 'grocery-food',
        ),
        Category(
          id: 'organic-health',
          name: 'Organic & Health Foods',
          parentId: 'grocery-food',
        ),
      ],
    ),

    // 15. Office & Stationery
    Category(
      id: 'office-stationery',
      name: 'Office & Stationery',
      emoji: '📝',
      displayOrder: 15,
      subcategories: [
        Category(
          id: 'office-supplies',
          name: 'Office Supplies (Pens, Paper)',
          parentId: 'office-stationery',
        ),
        Category(
          id: 'office-furniture-main',
          name: 'Office Furniture (Desks, Chairs)',
          parentId: 'office-stationery',
        ),
        Category(
          id: 'printer-ink',
          name: 'Printer & Ink',
          parentId: 'office-stationery',
        ),
        Category(
          id: 'school-supplies',
          name: 'School Supplies',
          parentId: 'office-stationery',
        ),
        Category(
          id: 'art-craft',
          name: 'Art & Craft Supplies',
          parentId: 'office-stationery',
        ),
        Category(
          id: 'organization',
          name: 'Organization (Files, Binders)',
          parentId: 'office-stationery',
        ),
      ],
    ),

    // 16. Garden & Outdoor
    Category(
      id: 'garden-outdoor',
      name: 'Garden & Outdoor',
      emoji: '🌱',
      displayOrder: 16,
      subcategories: [
        Category(
          id: 'plants-seeds',
          name: 'Plants & Seeds',
          parentId: 'garden-outdoor',
        ),
        Category(
          id: 'gardening-tools',
          name: 'Gardening Tools',
          parentId: 'garden-outdoor',
        ),
        Category(
          id: 'outdoor-decor',
          name: 'Outdoor Decor',
          parentId: 'garden-outdoor',
        ),
        Category(
          id: 'bbq-grills',
          name: 'BBQ & Grills',
          parentId: 'garden-outdoor',
        ),
        Category(
          id: 'patio-furniture',
          name: 'Patio Furniture',
          parentId: 'garden-outdoor',
        ),
        Category(
          id: 'lawn-care',
          name: 'Lawn Care',
          parentId: 'garden-outdoor',
        ),
      ],
    ),

    // 17. Jewelry & Watches
    Category(
      id: 'jewelry-watches',
      name: 'Jewelry & Watches',
      emoji: '⌚',
      displayOrder: 17,
      subcategories: [
        Category(
          id: 'fine-jewelry',
          name: 'Fine Jewelry (Gold, Silver)',
          parentId: 'jewelry-watches',
        ),
        Category(
          id: 'fashion-jewelry',
          name: 'Fashion Jewelry',
          parentId: 'jewelry-watches',
        ),
        Category(
          id: 'luxury-watches',
          name: 'Luxury Watches',
          parentId: 'jewelry-watches',
        ),
        Category(
          id: 'smart-watches',
          name: 'Smart Watches',
          parentId: 'jewelry-watches',
        ),
        Category(
          id: 'watch-accessories',
          name: 'Watch Accessories',
          parentId: 'jewelry-watches',
        ),
      ],
    ),

    // 18. Tools & Home Improvement
    Category(
      id: 'tools-improvement',
      name: 'Tools & Home Improvement',
      emoji: '🔧',
      displayOrder: 18,
      subcategories: [
        Category(
          id: 'power-tools',
          name: 'Power Tools',
          parentId: 'tools-improvement',
        ),
        Category(
          id: 'hand-tools',
          name: 'Hand Tools',
          parentId: 'tools-improvement',
        ),
        Category(
          id: 'hardware',
          name: 'Hardware',
          parentId: 'tools-improvement',
        ),
        Category(
          id: 'paint-supplies',
          name: 'Paint & Supplies',
          parentId: 'tools-improvement',
        ),
        Category(
          id: 'electrical',
          name: 'Electrical',
          parentId: 'tools-improvement',
        ),
        Category(
          id: 'plumbing',
          name: 'Plumbing',
          parentId: 'tools-improvement',
        ),
      ],
    ),

    // 19. Party & Gifts
    Category(
      id: 'party-gifts',
      name: 'Party & Gifts',
      emoji: '🎁',
      displayOrder: 19,
      subcategories: [
        Category(id: 'gift-cards', name: 'Gift Cards', parentId: 'party-gifts'),
        Category(id: 'gift-sets', name: 'Gift Sets', parentId: 'party-gifts'),
        Category(
          id: 'party-supplies',
          name: 'Party Supplies',
          parentId: 'party-gifts',
        ),
        Category(
          id: 'balloons-decorations',
          name: 'Balloons & Decorations',
          parentId: 'party-gifts',
        ),
        Category(
          id: 'greeting-cards',
          name: 'Greeting Cards',
          parentId: 'party-gifts',
        ),
        Category(
          id: 'personalized-gifts',
          name: 'Personalized Gifts',
          parentId: 'party-gifts',
        ),
      ],
    ),

    // 20. Specialty Categories
    Category(
      id: 'specialty',
      name: 'Specialty Categories',
      emoji: '✨',
      displayOrder: 20,
      subcategories: [
        Category(
          id: 'handmade-artisan',
          name: 'Handmade & Artisan',
          parentId: 'specialty',
        ),
        Category(
          id: 'vintage-collectibles',
          name: 'Vintage & Collectibles',
          parentId: 'specialty',
        ),
        Category(
          id: 'luxury-designer',
          name: 'Luxury & Designer',
          parentId: 'specialty',
        ),
        Category(
          id: 'eco-friendly',
          name: 'Eco-Friendly & Sustainable',
          parentId: 'specialty',
        ),
        Category(id: 'smart-home', name: 'Smart Home', parentId: 'specialty'),
        Category(
          id: 'travel-essentials',
          name: 'Travel Essentials',
          parentId: 'specialty',
        ),
      ],
    ),
  ];

  /// Get a flat list of all categories including subcategories
  static List<Category> get allCategories {
    List<Category> result = [];
    void addCategory(Category cat) {
      result.add(cat);
      for (final sub in cat.subcategories) {
        addCategory(sub);
      }
    }

    for (final cat in categories) {
      addCategory(cat);
    }
    return result;
  }

  /// Find a category by ID
  static Category? findById(String id) {
    Category? find(List<Category> cats) {
      for (final cat in cats) {
        if (cat.id == id) return cat;
        final found = find(cat.subcategories);
        if (found != null) return found;
      }
      return null;
    }

    return find(categories);
  }

  /// Get main categories only
  static List<Category> get mainCategories => categories;
}
