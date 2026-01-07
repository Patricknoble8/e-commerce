import '../models/product.dart';

/// Professional product catalog for e-commerce
/// Categories: Footwear, Apparel, Accessories, Sports Equipment
class ProductData {
  static const List<Product> products = [
    // ============ FOOTWEAR / SNEAKERS SECTION ============

    // Nike Sneakers Collection
    Product(
      id: '1',
      name: 'Nike Air Force 1 \'07',
      price: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500&h=500&fit=crop',
      description:
          'The radiance lives on in the Nike Air Force 1 \'07, the basketball original that puts a fresh spin on what you know best: durably stitched overlays, clean finishes and the perfect amount of flash to make you shine.',
      availableColors: ['White', 'Black', 'Blue', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '2',
      name: 'Nike Air Max 270',
      price: 160,
      imageUrl:
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
      description:
          'Nike\'s first lifestyle Air Max brings you style, comfort and big attitude in the Nike Air Max 270. The design draws inspiration from Air Max icons, showcasing Nike\'s greatest innovation with its large window and fresh array of colors.',
      availableColors: ['Black', 'White', 'Blue', 'Orange'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '3',
      name: 'Nike Dunk Low Retro',
      price: 115,
      imageUrl:
          'https://images.unsplash.com/photo-1628253747716-f9a1311d96e2?w=500&h=500&fit=crop',
      description:
          'Created for the hardwood but taken to the streets, the Nike Dunk Low Retro returns with crisp overlays and original team colors. This basketball icon channels \'80s vibes with premium leather in the upper that looks good and breaks in even better.',
      availableColors: ['White', 'Black', 'Blue', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '4',
      name: 'Nike Air Jordan 1 Mid',
      price: 125,
      imageUrl:
          'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500&h=500&fit=crop',
      description:
          'Inspired by the original that debuted in 1985, the Air Jordan 1 Mid offers fans a chance to follow in MJ\'s footsteps. Fresh color trims the clean, classic materials, imbuing modernity into a classic design.',
      availableColors: ['Black', 'White', 'Red', 'Blue'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '5',
      name: 'Nike React Infinity Run',
      price: 160,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'The Nike React Infinity Run Flyknit 2 continues to help keep you running. A refreshed upper uses Flywire technology that combines with Flyknit for support and breathability where you need it. Higher foam creates a softer feel.',
      availableColors: ['Black', 'White', 'Blue', 'Orange'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '6',
      name: 'Nike Blazer Mid \'77',
      price: 100,
      imageUrl:
          'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=500&h=500&fit=crop',
      description:
          'The Nike Blazer Mid \'77 Vintage returns with a classic look and feel. Exposed foam on the tongue and a special midsole finish make it look like you\'ve just pulled them from the history books.',
      availableColors: ['White', 'Black', 'Navy', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Nike',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Adidas Collection
    Product(
      id: '7',
      name: 'Adidas Ultraboost 22',
      price: 190,
      imageUrl:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&h=500&fit=crop',
      description:
          'These adidas running shoes redefine comfort with a Linear Energy Push system that increases forefoot bending stiffness for a more responsive toe-off. The adidas PRIMEKNIT upper adapts to your foot for all-day comfort.',
      availableColors: ['White', 'Black', 'Blue', 'Grey'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 25,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '8',
      name: 'Adidas Stan Smith',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1622902046580-2b47f47f5471?w=500&h=500&fit=crop',
      description:
          'Clean and simple. The adidas Stan Smith shoes stay true to their legacy with the same low-profile silhouette and minimalist look. A smooth leather upper keeps it sleek, while signature accents complete the classic aesthetic.',
      availableColors: ['White', 'Black', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '9',
      name: 'Adidas NMD_R1',
      price: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&h=500&fit=crop',
      description:
          'Born from a culture of innovation, the NMD fuses the best of adidas\' performance technology with streetwear style. These shoes bring a fresh perspective with a modern knit upper and responsive Boost cushioning.',
      availableColors: ['Black', 'White', 'Red', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Adidas',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '10',
      name: 'Adidas Superstar',
      price: 90,
      imageUrl:
          'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=500&h=500&fit=crop',
      description:
          'Launched in 1970 as a revolutionary basketball shoe, the adidas Superstar now rules the street with the same clean, classic style. This version features a leather upper and rubber shell toe for an authentic look.',
      availableColors: ['White', 'Black'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Puma Collection
    Product(
      id: '11',
      name: 'Puma Suede Classic XXI',
      price: 75,
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&h=500&fit=crop',
      description:
          'The Puma Suede hit the scene in 1968 and has been changing the game ever since. It\'s been worn by icons of every generation and it\'s stayed classic through it all. Instantly recognizable and constantly reinvented.',
      availableColors: ['Black', 'Blue', 'Red', 'Grey'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Puma',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '12',
      name: 'Puma RS-X',
      price: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=500&h=500&fit=crop',
      description:
          'The RS-X brings PUMA\'s Running System design into a new era with a bold, bulky silhouette. This evolution combines mesh and synthetic leather to create a standout look that turns heads on every street.',
      availableColors: ['White', 'Black', 'Blue', 'Orange'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Puma',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // New Balance Collection
    Product(
      id: '13',
      name: 'New Balance 550',
      price: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1579338559194-a162d19bf842?w=500&h=500&fit=crop',
      description:
          'The 550 is a basketball-inspired icon from 1989. Originally designed for the court, this low-profile silhouette was ahead of its time. Now it\'s back with premium leather construction and the classic NB styling you know and love.',
      availableColors: ['White', 'Black', 'Grey', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'New Balance',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '14',
      name: 'New Balance 574',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1574329310582-8f53be7a4f1b?w=500&h=500&fit=crop',
      description:
          'The 574 might be our most iconic sneaker. Why? Because it\'s worn by people who don\'t care if it\'s iconic. The 574 is a perfect blend of function and style that gives you that unmistakable New Balance look.',
      availableColors: ['Grey', 'Blue', 'Black', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'New Balance',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '15',
      name: 'New Balance 2002R',
      price: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&h=500&fit=crop',
      description:
          'Drawing from the 2000s running heritage, the 2002R combines premium materials with advanced cushioning technology. The result is a sophisticated sneaker that blends performance innovation with refined style.',
      availableColors: ['Grey', 'White', 'Black', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'New Balance',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Converse Collection
    Product(
      id: '16',
      name: 'Converse Chuck Taylor All Star',
      price: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500&h=500&fit=crop',
      description:
          'The Converse Chuck Taylor All Star is the most iconic sneaker of all time. Originally designed as a basketball shoe in 1917, it has become a cultural phenomenon worn by artists, musicians, and rebels worldwide.',
      availableColors: ['Black', 'White', 'Red', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Converse',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '17',
      name: 'Converse Chuck 70',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1605348532760-6753d2c43329?w=500&h=500&fit=crop',
      description:
          'Inspired by the original 1970s design, the Chuck 70 features premium canvas, a higher rubber foxing tape, and a cushioned footbed for enhanced comfort. A modern take on the classic that stays true to its roots.',
      availableColors: ['Black', 'White', 'Navy', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Converse',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // Vans Collection
    Product(
      id: '18',
      name: 'Vans Old Skool',
      price: 70,
      imageUrl:
          'https://images.unsplash.com/photo-1543508282-6319a3e2621f?w=500&h=500&fit=crop',
      description:
          'The Vans Old Skool was the first shoe to bear the iconic Vans Sidestripe (also known as the "jazz stripe"). This timeless classic has been worn by skaters and style icons for generations.',
      availableColors: ['Black', 'White', 'Blue', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Vans',
      discount: 10,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '19',
      name: 'Vans Authentic',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&h=500&fit=crop',
      description:
          'The Vans Authentic was the first shoe released by the brand in 1966. Simple, durable, and timeless, this low-top lace-up features sturdy canvas uppers and the classic Vans waffle outsole.',
      availableColors: ['Black', 'White', 'Navy', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Vans',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '20',
      name: 'Vans Sk8-Hi',
      price: 75,
      imageUrl:
          'https://images.unsplash.com/photo-1543508282-7d2fa9021e05?w=500&h=500&fit=crop',
      description:
          'The legendary high-top that has been worn by skateboarders since 1978. The Sk8-Hi was built on the Authentic as Vans\' first high-top, adding a padded collar for ankle support and protection.',
      availableColors: ['Black', 'White', 'Navy', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Vans',
      discount: 5,
      category: ProductCategory.footwear,
    ),

    // Nike Extended Collection
    Product(
      id: '21',
      name: 'Nike Air Max 90',
      price: 130,
      imageUrl:
          'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=500&h=500&fit=crop',
      description:
          'Nothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG roots with the iconic Waffle sole, stitched overlays and classic plastic details.',
      availableColors: ['White', 'Black', 'Grey', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '22',
      name: 'Nike Air Max 97',
      price: 175,
      imageUrl:
          'https://images.unsplash.com/photo-1605408499391-6368c628ef42?w=500&h=500&fit=crop',
      description:
          'The Air Max 97 takes inspiration from Japan\'s high-speed bullet trains. With its full-length Nike Air unit and eye-catching look, it delivers comfort and style on every step.',
      availableColors: ['Silver', 'Black', 'White', 'Gold'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 12,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '23',
      name: 'Nike SB Dunk High',
      price: 125,
      imageUrl:
          'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?w=500&h=500&fit=crop',
      description:
          'The Nike SB Dunk High brings classic basketball style with added padding and Zoom Air cushioning for skateboarding. Crafted from premium materials with iconic colorways.',
      availableColors: ['Black', 'White', 'Blue', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '24',
      name: 'Nike Air Jordan 4 Retro',
      price: 210,
      imageUrl:
          'https://images.unsplash.com/photo-1612015670817-0127d66d5b39?w=500&h=500&fit=crop',
      description:
          'The Air Jordan 4 Retro brings back the iconic silhouette from 1989. With mesh panels, visible Air cushioning, and the classic jumpman logo, it\'s a piece of sneaker history.',
      availableColors: ['White', 'Black', 'Red', 'Cement'],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '25',
      name: 'Nike Cortez',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=500&h=500&fit=crop',
      description:
          'The Nike Cortez is a true icon of sport and street style. With its lightweight design, foam midsole, and herringbone-pattern outsole, it\'s been a favorite since 1972.',
      availableColors: ['White', 'Black', 'Red', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '26',
      name: 'Nike Zoom Pegasus 39',
      price: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=500&h=500&fit=crop',
      description:
          'The Nike Zoom Pegasus 39 is built for every runner. With responsive cushioning and breathable mesh upper, it provides comfort mile after mile.',
      availableColors: ['Black', 'White', 'Blue', 'Orange'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 18,
      category: ProductCategory.footwear,
    ),

    // Adidas Extended Collection
    Product(
      id: '27',
      name: 'Adidas Yeezy Boost 350 V2',
      price: 220,
      imageUrl:
          'https://images.unsplash.com/photo-1600181516908-f7545a8f82b9?w=500&h=500&fit=crop',
      description:
          'The Adidas Yeezy Boost 350 V2 combines Kanye West\'s design vision with adidas innovation. Featuring Primeknit uppers and full-length Boost cushioning for unparalleled comfort.',
      availableColors: ['Black', 'White', 'Grey', 'Beige'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '28',
      name: 'Adidas Gazelle',
      price: 95,
      imageUrl:
          'https://images.unsplash.com/photo-1591348278863-65b90dfee7dc?w=500&h=500&fit=crop',
      description:
          'The Adidas Gazelle is a timeless classic. Originally a training shoe, it evolved into a streetwear icon with its suede upper and distinctive 3-Stripes.',
      availableColors: ['Blue', 'Black', 'Grey', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 10,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '29',
      name: 'Adidas ZX 2K Boost',
      price: 135,
      imageUrl:
          'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?w=500&h=500&fit=crop',
      description:
          'The ZX 2K Boost reimagines the iconic ZX series with modern Boost technology. A perfect fusion of heritage design and contemporary comfort.',
      availableColors: ['White', 'Black', 'Blue', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 22,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '30',
      name: 'Adidas Samba OG',
      price: 100,
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&h=500&fit=crop',
      description:
          'The Adidas Samba OG is a football icon turned fashion staple. With its distinctive gum rubber outsole and T-toe design, it\'s been a favorite since the 1950s.',
      availableColors: ['Black', 'White', 'Navy'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Puma Extended Collection
    Product(
      id: '31',
      name: 'Puma Clyde All-Pro',
      price: 125,
      imageUrl:
          'https://images.unsplash.com/photo-1562183241-b937e95585b6?w=500&h=500&fit=crop',
      description:
          'Named after NBA legend Walt "Clyde" Frazier, the Puma Clyde All-Pro brings classic basketball heritage with modern performance technology.',
      availableColors: ['White', 'Black', 'Blue', 'Red'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'Puma',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '32',
      name: 'Puma Future Rider',
      price: 90,
      imageUrl:
          'https://images.unsplash.com/photo-1627225925683-89a9b6846c83?w=500&h=500&fit=crop',
      description:
          'The Puma Future Rider takes inspiration from the iconic Rider series. With vibrant colors and retro styling, it\'s a bold statement piece for the modern sneaker lover.',
      availableColors: ['White', 'Black', 'Yellow', 'Pink'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Puma',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '33',
      name: 'Puma Thunder Spectra',
      price: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1520256862855-398228c41684?w=500&h=500&fit=crop',
      description:
          'The Puma Thunder Spectra embraces the chunky sneaker trend with bold colors and exaggerated proportions. A statement shoe that demands attention.',
      availableColors: ['Multi', 'Black', 'White', 'Grey'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Puma',
      discount: 25,
      category: ProductCategory.footwear,
    ),

    // New Balance Extended Collection
    Product(
      id: '34',
      name: 'New Balance 990v5',
      price: 185,
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&h=500&fit=crop',
      description:
          'The New Balance 990v5 represents the pinnacle of Made in USA craftsmanship. With premium pigskin and mesh uppers, it\'s a true luxury sneaker.',
      availableColors: ['Grey', 'Navy', 'Black'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'New Balance',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '35',
      name: 'New Balance 327',
      price: 100,
      imageUrl:
          'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=500&h=500&fit=crop',
      description:
          'The New Balance 327 reimagines the classic running aesthetic with an oversized N logo and asymmetrically applied extended midsole wrap.',
      availableColors: ['White', 'Black', 'Grey', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'New Balance',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '36',
      name: 'New Balance Fresh Foam 1080v12',
      price: 165,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&h=500&fit=crop',
      description:
          'The Fresh Foam 1080v12 delivers premium cushioning for runners. With Hypoknit upper and Fresh Foam midsole, it provides comfort for long distances.',
      availableColors: ['Blue', 'Black', 'White', 'Pink'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'New Balance',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Converse Extended Collection
    Product(
      id: '37',
      name: 'Converse One Star',
      price: 75,
      imageUrl:
          'https://images.unsplash.com/photo-1506152983158-b4a74a01c721?w=500&h=500&fit=crop',
      description:
          'The Converse One Star is a basketball icon turned street style essential. With its signature star logo and suede upper, it\'s been a favorite since the \'70s.',
      availableColors: ['Black', 'White', 'Navy', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Converse',
      discount: 12,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '38',
      name: 'Converse Run Star Hike',
      price: 110,
      imageUrl:
          'https://images.unsplash.com/photo-1542219550-37153d387c27?w=500&h=500&fit=crop',
      description:
          'The Run Star Hike elevates the classic Chuck Taylor with a dramatic platform sole. A bold, modern take on an iconic silhouette.',
      availableColors: ['Black', 'White', 'Yellow'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Converse',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Vans Extended Collection
    Product(
      id: '39',
      name: 'Vans Era',
      price: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=500&h=500&fit=crop',
      description:
          'The Vans Era is a skateboarding legend. Designed by Tony Alva and Stacy Peralta, it features the iconic padded collar and Vans waffle outsole.',
      availableColors: ['Black', 'White', 'Checkerboard', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Vans',
      discount: 8,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '40',
      name: 'Vans Slip-On',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1544441892-794166f1e3be?w=500&h=500&fit=crop',
      description:
          'The Vans Slip-On is the ultimate easy-on, easy-off shoe. With elastic side accents and a padded collar, it\'s been a skate and street favorite since 1977.',
      availableColors: ['Black', 'White', 'Checkerboard', 'Navy'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Vans',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Reebok Collection
    Product(
      id: '41',
      name: 'Reebok Classic Leather',
      price: 80,
      imageUrl:
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500&h=500&fit=crop',
      description:
          'The Reebok Classic Leather is a timeless icon. With its soft garment leather upper and die-cut EVA midsole, it\'s been delivering comfort since 1983.',
      availableColors: ['White', 'Black', 'Grey', 'Navy'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Reebok',
      discount: 18,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '42',
      name: 'Reebok Club C 85',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&h=500&fit=crop',
      description:
          'The Club C 85 vintage brings tennis style to the streets. With its clean, minimalist design and comfortable fit, it\'s a versatile everyday shoe.',
      availableColors: ['White', 'Black', 'Green'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Reebok',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '43',
      name: 'Reebok Nano X3',
      price: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
      description:
          'The Reebok Nano X3 is built for CrossFit. With superior stability, flexibility, and durability, it\'s ready for any workout you throw at it.',
      availableColors: ['Black', 'White', 'Blue', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Reebok',
      discount: 15,
      category: ProductCategory.sportswear,
    ),

    // Jordan Brand Collection
    Product(
      id: '44',
      name: 'Air Jordan 3 Retro',
      price: 200,
      imageUrl:
          'https://images.unsplash.com/photo-1612015670817-0127d66d5b39?w=500&h=500&fit=crop',
      description:
          'The Air Jordan 3 introduced the iconic Jumpman logo and visible Air. With elephant print and premium leather, it\'s a masterpiece of sneaker design.',
      availableColors: ['White', 'Black', 'Fire Red'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '45',
      name: 'Air Jordan 11 Retro',
      price: 220,
      imageUrl:
          'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=500&h=500&fit=crop',
      description:
          'The Air Jordan 11 is Michael Jordan\'s favorite. With patent leather mudguard and carbon fiber spring plate, it\'s a perfect blend of style and performance.',
      availableColors: ['White', 'Black', 'Bred', 'Concord'],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Asics Collection
    Product(
      id: '46',
      name: 'Asics Gel-Lyte III',
      price: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'The Asics Gel-Lyte III is a running icon. Featuring the signature split-tongue design and GEL cushioning technology, it combines retro style with modern comfort.',
      availableColors: ['White', 'Black', 'Grey', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Asics',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '47',
      name: 'Asics Gel-Kayano 29',
      price: 160,
      imageUrl:
          'https://images.unsplash.com/photo-1562183241-b937e95585b6?w=500&h=500&fit=crop',
      description:
          'The Gel-Kayano 29 is Asics\' premium stability running shoe. With advanced cushioning and support features, it\'s built for long-distance comfort.',
      availableColors: ['Black', 'White', 'Blue', 'Pink'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Asics',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '48',
      name: 'Asics Gel-Nimbus 25',
      price: 170,
      imageUrl:
          'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=500&h=500&fit=crop',
      description:
          'Experience maximum cushioning with the Gel-Nimbus 25. Featuring FF BLAST+ ECO cushioning and PureGEL technology for the softest ride yet.',
      availableColors: ['Black', 'White', 'Grey', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Asics',
      discount: 12,
      category: ProductCategory.footwear,
    ),

    // On Running Collection
    Product(
      id: '49',
      name: 'On Cloud 5',
      price: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=500&h=500&fit=crop',
      description:
          'The On Cloud 5 revolutionizes running with CloudTec cushioning. Lightweight, flexible, and incredibly comfortable for everyday wear.',
      availableColors: ['White', 'Black', 'Grey', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'On',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '50',
      name: 'On Cloudmonster',
      price: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'The Cloudmonster delivers maximum cushioning with oversized CloudTec pods. Built for runners who want soft landings and powerful take-offs.',
      availableColors: ['White', 'Black', 'Blue', 'Orange'],
      availableSizes: [39, 40, 41, 42, 43, 44],
      brand: 'On',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // ============ APPAREL / CLOTHING SECTION ============

    // Nike Apparel Collection
    Product(
      id: '51',
      name: 'Nike Dri-FIT Performance T-Shirt',
      price: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop',
      description:
          'Stay dry and comfortable with Nike\'s advanced Dri-FIT technology. Perfect for training, running, or everyday wear.',
      availableColors: ['Black', 'White', 'Grey', 'Navy', 'Blue'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Nike',
      discount: 20,
      category: ProductCategory.clothing,
    ),
    Product(
      id: '52',
      name: 'Nike Sportswear Club Hoodie',
      price: 70,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Classic comfort meets modern style. This lightweight hoodie features a kangaroo pocket and adjustable drawstrings.',
      availableColors: ['Black', 'White', 'Grey', 'Navy'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Nike',
      discount: 15,
      category: ProductCategory.clothing,
    ),
    Product(
      id: '53',
      name: 'Nike Academy Pro Shorts',
      price: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1582142407892-5c1bf4e82f16?w=500&h=500&fit=crop',
      description:
          'Lightweight and breathable soccer shorts. Dri-FIT technology keeps you dry during intense training sessions.',
      availableColors: ['Black', 'Navy', 'White', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // Adidas Apparel Collection
    Product(
      id: '54',
      name: 'Adidas Essentials Linear Logo T-Shirt',
      price: 30,
      imageUrl:
          'https://images.unsplash.com/photo-1562157873-3afe6d2f72e9?w=500&h=500&fit=crop',
      description:
          'A wardrobe essential. Soft cotton t-shirt with the iconic Adidas logo. Simple, timeless, and versatile.',
      availableColors: ['White', 'Black', 'Grey', 'Navy', 'Navy Striped'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Adidas',
      discount: 25,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '55',
      name: 'Adidas Tiro 23 Track Jacket',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop',
      description:
          'Classic adidas tracksuit jacket with 3-stripes design. Perfect for warm-ups or casual wear.',
      availableColors: ['Black', 'Navy', 'White', 'Grey'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Adidas',
      discount: 20,
      category: ProductCategory.sportswear,
    ),
    Product(
      id: '56',
      name: 'Adidas Essentials Sweatpants',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=500&h=500&fit=crop',
      description:
          'Comfortable and classic. Adidas sweatpants made from soft fleece with tapered legs.',
      availableColors: ['Black', 'Grey', 'Navy', 'White'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Puma Apparel Collection
    Product(
      id: '57',
      name: 'Puma Essential Logo T-Shirt',
      price: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1503342394128-c104adf2da6f?w=500&h=500&fit=crop',
      description:
          'Stay casual in comfort. Puma\'s essential t-shirt with the iconic cat logo.',
      availableColors: ['White', 'Black', 'Grey', 'Red', 'Blue'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Puma',
      discount: 18,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '58',
      name: 'Puma Rebel Hoodie',
      price: 65,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Bold and comfortable. Features drawstring adjustments and kangaroo pockets.',
      availableColors: ['Black', 'White', 'Navy', 'Grey'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Puma',
      discount: 22,
      category: ProductCategory.footwear,
    ),

    // Champion Apparel Collection
    Product(
      id: '59',
      name: 'Champion Classic Logo T-Shirt',
      price: 32,
      imageUrl:
          'https://images.unsplash.com/photo-1503342394128-c104adf2da6f?w=500&h=500&fit=crop',
      description:
          'Heritage meets comfort. Champion\'s iconic embroidered logo on premium cotton.',
      availableColors: ['White', 'Black', 'Grey', 'Navy', 'Maroon'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Champion',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '60',
      name: 'Champion Reverse Weave Hoodie',
      price: 95,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Premium comfort with reverse weave construction. The original hoodie.',
      availableColors: ['Black', 'Grey', 'Navy', 'White', 'Maroon'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Champion',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // ============ ACCESSORIES SECTION ============

    // Bags & Backpacks
    Product(
      id: '61',
      name: 'Nike Sportswear Backpack',
      price: 65,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      description:
          'Spacious Nike backpack with padded straps and multiple compartments. Perfect for school, work, or travel.',
      availableColors: ['Black', 'Navy', 'Grey', 'White'],
      availableSizes: ['One Size'],
      brand: 'Nike',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '62',
      name: 'Adidas Essentials Linear Duffel Bag',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      description:
          'Compact gym duffel with 3-stripes design. Durable and stylish for your training gear.',
      availableColors: ['Black', 'Navy', 'White', 'Grey'],
      availableSizes: ['One Size'],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '63',
      name: 'Puma Phase Backpack',
      price: 50,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      description:
          'Sleek and functional. Puma\'s classic backpack with laptop compartment.',
      availableColors: ['Black', 'White', 'Navy', 'Grey'],
      availableSizes: ['One Size'],
      brand: 'Puma',
      discount: 25,
      category: ProductCategory.footwear,
    ),

    // Headwear
    Product(
      id: '64',
      name: 'Nike Sportswear Club Cap',
      price: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop',
      description:
          'Classic cotton cap with embroidered Swoosh logo. One size fits all with adjustable strap.',
      availableColors: ['Black', 'White', 'Navy', 'Grey', 'Red'],
      availableSizes: ['One Size'],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '65',
      name: 'Adidas Trefoil Beanie',
      price: 22,
      imageUrl:
          'https://images.unsplash.com/photo-1578629270098-ef3d1f8e5ab6?w=500&h=500&fit=crop',
      description:
          'Stay warm in style. Acrylic knit beanie with iconic Adidas trefoil.',
      availableColors: ['Black', 'Navy', 'White', 'Grey', 'Red'],
      availableSizes: ['One Size'],
      brand: 'Adidas',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // Socks
    Product(
      id: '66',
      name: 'Nike Everyday Cushioned Socks (3-Pack)',
      price: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Comfortable everyday socks with cushioning. Pack of 3 pairs.',
      availableColors: ['Black', 'White', 'Grey'],
      availableSizes: ['S', 'M', 'L'],
      brand: 'Nike',
      discount: 20,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '67',
      name: 'Adidas Cushioned Running Socks (6-Pack)',
      price: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Moisture-wicking running socks with extra cushioning. Pack of 6 pairs.',
      availableColors: ['Black', 'White'],
      availableSizes: ['S', 'M', 'L'],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Belts
    Product(
      id: '68',
      name: 'Nike Reversible Leather Belt',
      price: 40,
      imageUrl:
          'https://images.unsplash.com/photo-1595777707802-08d375a01415?w=500&h=500&fit=crop',
      description:
          'Premium leather belt with reversible design. Genuine leather with metal buckle.',
      availableColors: ['Black/Brown', 'Black', 'Brown'],
      availableSizes: ['S', 'M', 'L', 'XL'],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '69',
      name: 'Adidas Webbing Belt',
      price: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1595777707802-08d375a01415?w=500&h=500&fit=crop',
      description:
          'Casual webbing belt with Adidas logo buckle. Adjustable one size fits all.',
      availableColors: ['Black', 'Navy', 'White', 'Grey'],
      availableSizes: ['One Size'],
      brand: 'Adidas',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // ============ SPORTS EQUIPMENT SECTION ============

    // Footballs & Balls
    Product(
      id: '70',
      name: 'Adidas Tiro League Soccer Ball',
      price: 50,
      imageUrl:
          'https://images.unsplash.com/photo-1579953139150-a1f0e1c3d1ef?w=500&h=500&fit=crop',
      description:
          'Official match soccer ball with thermal bonded seams. Consistent performance and durability.',
      availableColors: ['White/Black', 'White/Red', 'White/Blue'],
      availableSizes: ['Size 5'],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.sportswear,
    ),
    Product(
      id: '71',
      name: 'Nike Strike Soccer Ball',
      price: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1579953139150-a1f0e1c3d1ef?w=500&h=500&fit=crop',
      description:
          'Responsive and durable soccer ball. Perfect for training and recreational play.',
      availableColors: ['White/Black', 'White/Yellow', 'White/Orange'],
      availableSizes: ['Size 5'],
      brand: 'Nike',
      discount: 15,
      category: ProductCategory.sportswear,
    ),

    // Water Bottles
    Product(
      id: '72',
      name: 'Nike Stainless Steel Water Bottle',
      price: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e9?w=500&h=500&fit=crop',
      description:
          'Keep your drinks cold or hot. Double-wall insulated stainless steel bottle.',
      availableColors: ['Black', 'Navy', 'White', 'Red'],
      availableSizes: ['One Size (750ml)'],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '73',
      name: 'Adidas Classic Water Bottle',
      price: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e9?w=500&h=500&fit=crop',
      description:
          'Lightweight and eco-friendly. Adidas classic water bottle made from recycled materials.',
      availableColors: ['Black', 'White', 'Navy'],
      availableSizes: ['One Size (500ml)'],
      brand: 'Adidas',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    // Fitness Equipment
    Product(
      id: '74',
      name: 'Nike Training Resistance Bands Set',
      price: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1584524688144-23d18e92b126?w=500&h=500&fit=crop',
      description:
          'Complete resistance training set with 5 bands of varying resistance levels.',
      availableColors: ['Multicolor'],
      availableSizes: ['One Size'],
      brand: 'Nike',
      discount: 25,
      category: ProductCategory.sportswear,
    ),
    Product(
      id: '75',
      name: 'Adidas Yoga Mat (Premium)',
      price: 65,
      imageUrl:
          'https://images.unsplash.com/photo-1594737177126-cfe83ae6e2e2?w=500&h=500&fit=crop',
      description:
          'Non-slip premium yoga mat. Extra thick for comfort and durability.',
      availableColors: ['Black', 'Purple', 'Blue', 'Green'],
      availableSizes: ['One Size (173x61cm)'],
      brand: 'Adidas',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // Protective Gear
    Product(
      id: '76',
      name: 'Nike Protective Knee Pad',
      price: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25ddfcbf042?w=500&h=500&fit=crop',
      description:
          'Comfortable knee pad with gel cushioning. Perfect for volleyball, basketball, or skateboarding.',
      availableColors: ['Black', 'White', 'Blue'],
      availableSizes: ['S', 'M', 'L', 'XL'],
      brand: 'Nike',
      discount: 0,
      category: ProductCategory.sportswear,
    ),
    Product(
      id: '77',
      name: 'Adidas Wrist Support Brace',
      price: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25ddfcbf042?w=500&h=500&fit=crop',
      description: 'Professional-grade wrist support for training and sports.',
      availableColors: ['Black', 'Grey'],
      availableSizes: ['S', 'M', 'L'],
      brand: 'Adidas',
      discount: 15,
      category: ProductCategory.sportswear,
    ),

    // ============ PREMIUM/LUXURY SECTION ============
    Product(
      id: '78',
      name: 'The North Face Winter Parka',
      price: 320,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Premium insulated parka with down-fill. Water and wind resistant. Perfect for harsh winter conditions.',
      availableColors: ['Black', 'Navy', 'Grey', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'The North Face',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '79',
      name: 'Columbia Fleece Jacket',
      price: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Lightweight fleece with thermal comfort. Ideal for layering and outdoor activities.',
      availableColors: ['Black', 'Grey', 'Navy', 'Blue'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Columbia',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    // ============ LUXURY / PREMIUM BRANDS ============

    // Gucci Collection
    Product(
      id: '80',
      name: 'Gucci GG Marmont Leather Sneaker',
      price: 590,
      imageUrl:
          'https://images.unsplash.com/photo-1543163521-9145f931a38f?w=500&h=500&fit=crop',
      description:
          'Premium leather sneaker with iconic Gucci GG monogram. Crafted with Italian craftsmanship and luxury materials.',
      availableColors: ['White', 'Black', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Gucci',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '81',
      name: 'Gucci Matelassé Quilted Leather Jacket',
      price: 2800,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Iconic matelassé quilted leather jacket. A timeless piece from the Gucci collection with signature marmont details.',
      availableColors: ['Black', 'Red', 'White'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      brand: 'Gucci',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // Louis Vuitton Collection
    Product(
      id: '82',
      name: 'Louis Vuitton Monogram Canvas Backpack',
      price: 1450,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      description:
          'Classic Louis Vuitton backpack with iconic monogram canvas and leather details. Perfect for travel and daily use.',
      availableColors: ['Brown', 'Black'],
      availableSizes: ['One Size'],
      brand: 'Louis Vuitton',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '83',
      name: 'Louis Vuitton Run Away Leather Sneaker',
      price: 890,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'Sophisticated leather sneaker with LV signature details. Combines elegance with modern comfort.',
      availableColors: ['White', 'Black', 'Pink'],
      availableSizes: [36, 37, 38, 39, 40, 41, 42],
      brand: 'Louis Vuitton',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Balenciaga Collection
    Product(
      id: '84',
      name: 'Balenciaga Triple S Sneaker',
      price: 845,
      imageUrl:
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
      description:
          'Iconic chunky sneaker with triple sole design. Premium materials and distinctive Balenciaga aesthetic.',
      availableColors: ['White/Black', 'Grey', 'Black'],
      availableSizes: [38, 39, 40, 41, 42, 43],
      brand: 'Balenciaga',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '85',
      name: 'Balenciaga Oversized Hoodie',
      price: 625,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Premium oversized hoodie with bold Balenciaga branding. Made from high-quality cotton blend.',
      availableColors: ['Black', 'White', 'Grey'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      brand: 'Balenciaga',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    // ============ SPORTS & LIFESTYLE BRANDS ============

    // Salomon Collection
    Product(
      id: '86',
      name: 'Salomon Speedcross 5 Trail Shoes',
      price: 135,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'High-performance trail running shoes with aggressive tread and responsive cushioning. Designed for off-road running.',
      availableColors: ['Black', 'Orange', 'Blue', 'Grey'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Salomon',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '87',
      name: 'Salomon Bonellia Snow Jacket',
      price: 280,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Waterproof and insulated snow jacket. Perfect for winter sports and cold weather activities.',
      availableColors: ['White', 'Black', 'Red', 'Blue'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Salomon',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Timberland Collection
    Product(
      id: '88',
      name: 'Timberland 6-Inch Premium Boots',
      price: 195,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'Iconic waterproof leather boots. Built for durability and rugged outdoor use with traditional craftsmanship.',
      availableColors: ['Wheat', 'Black', 'Brown'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Timberland',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '89',
      name: 'Timberland Earthkeepers Down Parka',
      price: 375,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Sustainable down parka with recycled materials. Warm, eco-friendly, and stylish for winter weather.',
      availableColors: ['Navy', 'Black', 'Grey', 'Olive'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Timberland',
      discount: 25,
      category: ProductCategory.footwear,
    ),

    // Saucony Collection
    Product(
      id: '90',
      name: 'Saucony Ride 15 Running Shoe',
      price: 130,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'Comfortable daily running shoe with responsive cushioning and breathable mesh. Ideal for all distances.',
      availableColors: ['Black', 'White', 'Blue', 'Red'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Saucony',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Brooks Collection
    Product(
      id: '91',
      name: 'Brooks Ghost 14 Running Shoes',
      price: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'Premium running shoes with soft cushioning and smooth transitions. Perfect for long-distance runners.',
      availableColors: ['Black', 'White', 'Navy', 'Purple'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'Brooks',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // New Balance Extended Premium Collection
    Product(
      id: '92',
      name: 'New Balance 1080v13 Premium Running Shoe',
      price: 185,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
      description:
          'Premium cushioned running shoe with Fresh Foam technology. Engineered for comfort and performance.',
      availableColors: ['White', 'Black', 'Grey', 'Blue'],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      brand: 'New Balance',
      discount: 12,
      category: ProductCategory.footwear,
    ),

    // ============ CASUAL & LIFESTYLE BRANDS ============

    // Tommy Hilfiger Collection
    Product(
      id: '93',
      name: 'Tommy Hilfiger Classic Polo Shirt',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1503342394128-c104adf2da6f?w=500&h=500&fit=crop',
      description:
          'Classic polo shirt with Tommy Hilfiger flag logo. Made from premium cotton pique.',
      availableColors: ['White', 'Navy', 'Light Blue', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Tommy Hilfiger',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '94',
      name: 'Tommy Hilfiger Windbreaker Jacket',
      price: 125,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Lightweight windbreaker with signature Tommy stripes. Perfect for layering and active wear.',
      availableColors: ['Navy', 'White', 'Red', 'Black'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Tommy Hilfiger',
      discount: 18,
      category: ProductCategory.footwear,
    ),

    // Calvin Klein Collection
    Product(
      id: '95',
      name: 'Calvin Klein Minimalist T-Shirt',
      price: 65,
      imageUrl:
          'https://images.unsplash.com/photo-1503342394128-c104adf2da6f?w=500&h=500&fit=crop',
      description:
          'Clean and minimal design with Calvin Klein branding. Premium cotton construction.',
      availableColors: ['White', 'Black', 'Grey', 'Navy'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Calvin Klein',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '96',
      name: 'Calvin Klein Performance Leggings',
      price: 95,
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=500&h=500&fit=crop',
      description:
          'High-performance leggings with moisture-wicking technology. Ideal for workouts and active lifestyle.',
      availableColors: ['Black', 'Navy', 'Grey'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      brand: 'Calvin Klein',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // Ralph Lauren Collection
    Product(
      id: '97',
      name: 'Ralph Lauren Wool Sweater',
      price: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Premium wool crew neck sweater with Ralph Lauren embroidered pony logo. Classic sophistication.',
      availableColors: ['Navy', 'White', 'Black', 'Burgundy'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Ralph Lauren',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '98',
      name: 'Ralph Lauren Classic Denim Jeans',
      price: 145,
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=500&h=500&fit=crop',
      description:
          'Premium denim with iconic Ralph Lauren styling. Comfortable fit with durable construction.',
      availableColors: ['Dark Blue', 'Light Blue', 'Black'],
      availableSizes: ['28', '30', '32', '34', '36', '38', '40'],
      brand: 'Ralph Lauren',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // ============ OUTDOOR & ADVENTURE BRANDS ============

    // Arc'teryx Collection
    Product(
      id: '99',
      name: 'Arc\'teryx Alpha Shell Jacket',
      price: 425,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Premium weather-resistant shell jacket. Engineered for mountain activities and extreme outdoor conditions.',
      availableColors: ['Black', 'Grey', 'Blue', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Arc\'teryx',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Patagonia Collection
    Product(
      id: '100',
      name: 'Patagonia Synchilla Fleece Pullover',
      price: 165,
      imageUrl:
          'https://images.unsplash.com/photo-1556821552-5f94c8f18ce2?w=500&h=500&fit=crop',
      description:
          'Warm and comfortable recycled polyester fleece. Eco-friendly construction perfect for outdoor adventures.',
      availableColors: ['Black', 'Grey', 'Navy', 'Green'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Patagonia',
      discount: 12,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '101',
      name: 'Patagonia Better Chill Down Jacket',
      price: 249,
      imageUrl:
          'https://images.unsplash.com/photo-1539533057838-7c50c596dcc9?w=500&h=500&fit=crop',
      description:
          'Lightweight down jacket with responsible sourcing. Perfect for layering in cold weather.',
      availableColors: ['Black', 'Navy', 'Green', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      brand: 'Patagonia',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ SPORTS EQUIPMENT & ACCESSORIES ============

    // Spalding Basketball Collection
    Product(
      id: '102',
      name: 'Spalding NBA Official Basketball',
      price: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1579953139150-a1f0e1c3d1ef?w=500&h=500&fit=crop',
      description:
          'Official NBA basketball. Premium leather construction with excellent grip and consistent bounce.',
      availableColors: ['Orange/Black'],
      availableSizes: ['Size 7'],
      brand: 'Spalding',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // Wilson Sports Collection
    Product(
      id: '103',
      name: 'Wilson Pro Staff Tennis Racket',
      price: 280,
      imageUrl:
          'https://images.unsplash.com/photo-1579953139150-a1f0e1c3d1ef?w=500&h=500&fit=crop',
      description:
          'Professional tennis racket with premium materials. Used by professional players worldwide.',
      availableColors: ['Black', 'White', 'Blue'],
      availableSizes: ['4.25\'\'', '4.375\'\'', '4.5\'\''],
      brand: 'Wilson',
      discount: 10,
      category: ProductCategory.sportswear,
    ),

    // Titleist Golf Collection
    Product(
      id: '104',
      name: 'Titleist Pro V1 Golf Balls (Dozen)',
      price: 48,
      imageUrl:
          'https://images.unsplash.com/photo-1579953139150-a1f0e1c3d1ef?w=500&h=500&fit=crop',
      description:
          'Premium golf balls used by professionals. Exceptional distance and control.',
      availableColors: ['White', 'Yellow'],
      availableSizes: ['One Size'],
      brand: 'Titleist',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // Everlast Boxing Collection
    Product(
      id: '105',
      name: 'Everlast Pro Boxing Gloves',
      price: 95,
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25ddfcbf042?w=500&h=500&fit=crop',
      description:
          'Professional boxing gloves with leather construction. Provides excellent wrist support and padding.',
      availableColors: ['Black', 'Red', 'Blue', 'White'],
      availableSizes: ['8oz', '10oz', '12oz', '14oz', '16oz'],
      brand: 'Everlast',
      discount: 20,
      category: ProductCategory.sportswear,
    ),

    // Intrepid Gym Equipment
    Product(
      id: '106',
      name: 'Intrepid Adjustable Dumbbell Set',
      price: 299,
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25ddfcbf042?w=500&h=500&fit=crop',
      description:
          'Premium adjustable dumbbells with quick adjustment mechanism. Space-saving fitness solution.',
      availableColors: ['Black', 'Silver'],
      availableSizes: ['5-25 lbs', '25-50 lbs'],
      brand: 'Intrepid',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // ============ ELECTRONICS & TECHNOLOGY ============

    // Apple Collection
    Product(
      id: '107',
      name: 'Apple AirPods Pro (2nd Generation)',
      price: 249,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
      description:
          'Premium wireless earbuds with active noise cancellation. Exceptional sound quality and seamless Apple integration.',
      availableColors: ['White'],
      availableSizes: ['One Size'],
      brand: 'Apple',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '108',
      name: 'Apple Watch Series 8',
      price: 399,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
      description:
          'Advanced health and fitness smartwatch. ECG app, blood oxygen monitoring, and all-day battery life.',
      availableColors: ['Midnight', 'Starlight', 'Silver', 'Gold', 'Red'],
      availableSizes: ['41mm', '45mm'],
      brand: 'Apple',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '109',
      name: 'Apple iPad Air (5th Gen)',
      price: 599,
      imageUrl:
          'https://images.unsplash.com/photo-1560707303-4e980ce876ad?w=500&h=500&fit=crop',
      description:
          'Powerful tablet with M1 chip. Perfect for productivity, creativity, and entertainment.',
      availableColors: ['Space Grey', 'Silver', 'Blue', 'Purple', 'Pink'],
      availableSizes: ['One Size'],
      brand: 'Apple',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Samsung Collection
    Product(
      id: '110',
      name: 'Samsung Galaxy Buds2 Pro',
      price: 229,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
      description:
          'Premium wireless earbuds with intelligent ANC. Superior sound and comfort for all-day wear.',
      availableColors: ['Phantom Black', 'Phantom Silver', 'Phantom Violet'],
      availableSizes: ['One Size'],
      brand: 'Samsung',
      discount: 15,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '111',
      name: 'Samsung Galaxy Watch5 Pro',
      price: 429,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
      description:
          'Rugged smartwatch with Sapphire crystal. Built for adventure with comprehensive health tracking.',
      availableColors: ['Black', 'Gray', 'Silver'],
      availableSizes: ['40mm', '44mm'],
      brand: 'Samsung',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Sony Collection
    Product(
      id: '112',
      name: 'Sony WH-1000XM5 Headphones',
      price: 399,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
      description:
          'Industry-leading noise cancellation headphones. Premium sound quality with 30-hour battery life.',
      availableColors: ['Black', 'Silver'],
      availableSizes: ['One Size'],
      brand: 'Sony',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Canon Camera Collection
    Product(
      id: '113',
      name: 'Canon EOS R50 Mirrorless Camera',
      price: 749,
      imageUrl:
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500&h=500&fit=crop',
      description:
          'Compact mirrorless camera with 24MP sensor. Perfect for photography enthusiasts and content creators.',
      availableColors: ['Black', 'White'],
      availableSizes: ['One Size'],
      brand: 'Canon',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // GoPro Collection
    Product(
      id: '114',
      name: 'GoPro Hero 11 Black',
      price: 499,
      imageUrl:
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500&h=500&fit=crop',
      description:
          'Professional action camera. 5.3K recording, rugged design, perfect for extreme sports.',
      availableColors: ['Black'],
      availableSizes: ['One Size'],
      brand: 'GoPro',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    // ============ HOME & LIVING ============

    // IKEA Furniture Collection
    Product(
      id: '115',
      name: 'IKEA BILLY Bookcase',
      price: 89,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop',
      description:
          'Classic modular bookcase. Perfect for organizing books and displaying décor. Easy assembly.',
      availableColors: ['White', 'Black', 'Brown', 'Birch'],
      availableSizes: ['One Size'],
      brand: 'IKEA',
      discount: 0,
      category: ProductCategory.footwear,
    ),
    Product(
      id: '116',
      name: 'IKEA KALLAX Storage Unit',
      price: 69,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop',
      description:
          'Versatile shelving unit with customizable compartments. Ideal for any room in your home.',
      availableColors: ['White', 'Black', 'Walnut', 'Grey'],
      availableSizes: ['2x2', '4x4', '5x5'],
      brand: 'IKEA',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Herman Miller Office Furniture
    Product(
      id: '117',
      name: 'Herman Miller Aeron Chair',
      price: 1395,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop',
      description:
          'Premium ergonomic office chair. Scientifically designed for comfort and support during long work sessions.',
      availableColors: ['Black', 'Grey', 'White'],
      availableSizes: ['One Size'],
      brand: 'Herman Miller',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Philips Lighting
    Product(
      id: '118',
      name: 'Philips Hue Smart Light Bulb',
      price: 29,
      imageUrl:
          'https://images.unsplash.com/photo-1565636192335-14e9edc7d3e0?w=500&h=500&fit=crop',
      description:
          'Smart LED light bulb with 16 million colors. Control brightness and color via smartphone app.',
      availableColors: ['White'],
      availableSizes: ['E27', 'E14'],
      brand: 'Philips',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // Le Creuset Cookware
    Product(
      id: '119',
      name: 'Le Creuset Enameled Cast Iron Pot',
      price: 399,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d782a?w=500&h=500&fit=crop',
      description:
          'Premium French cookware. Perfect heat distribution and heat retention for all cooking needs.',
      availableColors: [
        'Flame Orange',
        'Cerise Red',
        'Caribbean Blue',
        'Black',
      ],
      availableSizes: ['3.5L', '5.5L', '7.25L'],
      brand: 'Le Creuset',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ BEAUTY & PERSONAL CARE ============

    // Estée Lauder Collection
    Product(
      id: '120',
      name: 'Estée Lauder Advanced Night Repair Eye Serum',
      price: 68,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Premium eye serum. Reduces fine lines and dark circles for a youthful appearance.',
      availableColors: ['Clear'],
      availableSizes: ['15ml', '30ml'],
      brand: 'Estée Lauder',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // MAC Cosmetics Collection
    Product(
      id: '121',
      name: 'MAC Fix+Setting Spray',
      price: 26,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Professional makeup setting spray. Locks makeup in place for 12+ hours without flaking.',
      availableColors: ['Clear'],
      availableSizes: ['100ml'],
      brand: 'MAC',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Dyson Hair Care
    Product(
      id: '122',
      name: 'Dyson Supersonic Hair Dryer',
      price: 399,
      imageUrl:
          'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=500&h=500&fit=crop',
      description:
          'Revolutionary hair dryer with intelligent heat control. Fast drying with minimal heat damage.',
      availableColors: ['White', 'Black', 'Pink', 'Gold'],
      availableSizes: ['One Size'],
      brand: 'Dyson',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Chanel Fragrance Collection
    Product(
      id: '123',
      name: 'Chanel No. 5 Eau de Parfum',
      price: 125,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Iconic luxury fragrance. Timeless elegance with floral and aldehyde notes.',
      availableColors: ['Clear'],
      availableSizes: ['50ml', '100ml'],
      brand: 'Chanel',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Dermalogica Skincare
    Product(
      id: '124',
      name: 'Dermalogica Clearing Skin Wash',
      price: 38,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Professional acne cleanser. Removes impurities without disrupting skin\'s natural pH.',
      availableColors: ['White'],
      availableSizes: ['250ml'],
      brand: 'Dermalogica',
      discount: 12,
      category: ProductCategory.footwear,
    ),

    // ============ BOOKS & MEDIA ============

    // Book Collection
    Product(
      id: '125',
      name: 'The Midnight Library by Matt Haig',
      price: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1507842217343-583f20270319?w=500&h=500&fit=crop',
      description:
          'Award-winning fiction novel. Explores themes of hope, regret, and infinite possibilities.',
      availableColors: ['Hardcover', 'Paperback'],
      availableSizes: ['One Size'],
      brand: 'Penguin Books',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Vinyl Records Collection
    Product(
      id: '126',
      name: 'The Beatles - Abbey Road Vinyl Record',
      price: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&h=500&fit=crop',
      description:
          'Classic 180g vinyl record. Remastered for exceptional sound quality and warm tone.',
      availableColors: ['Black'],
      availableSizes: ['One Size'],
      brand: 'The Beatles',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Board Games
    Product(
      id: '127',
      name: 'Catan Strategy Board Game',
      price: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=500&h=500&fit=crop',
      description:
          'Award-winning strategy game. Perfect for family and friends. Ages 10+, 2-4 players.',
      availableColors: ['Multi'],
      availableSizes: ['One Size'],
      brand: 'Catan',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // ============ FOOD & BEVERAGES ============

    // Nespresso Collection
    Product(
      id: '128',
      name: 'Nespresso Vertuo Coffee Machine',
      price: 199,
      imageUrl:
          'https://images.unsplash.com/photo-1517701550927-30cf4ba20d6d?w=500&h=500&fit=crop',
      description:
          'Premium coffee machine with centrifusion technology. Makes espresso and coffee in 30 seconds.',
      availableColors: ['Black', 'Silver', 'White', 'Red'],
      availableSizes: ['One Size'],
      brand: 'Nespresso',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Twinings Tea Collection
    Product(
      id: '129',
      name: 'Twinings Assorted Tea Collection Box',
      price: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1597318372169-a549a5ad00d4?w=500&h=500&fit=crop',
      description:
          'Premium tea selection box. Includes black, green, herbal, and fruit teas. 50 tea bags.',
      availableColors: ['Multi'],
      availableSizes: ['One Size'],
      brand: 'Twinings',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Lindt Chocolate Collection
    Product(
      id: '130',
      name: 'Lindt Premium Chocolate Assortment',
      price: 22,
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-51c6662a9a6d?w=500&h=500&fit=crop',
      description:
          'Luxury chocolate assortment. 20 delicious flavored truffles from premium cocoa.',
      availableColors: ['Multi'],
      availableSizes: ['250g'],
      brand: 'Lindt',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // ============ BABY & KIDS ============

    // Fisher-Price Baby Collection
    Product(
      id: '131',
      name: 'Fisher-Price Laugh & Learn Baby Rocker',
      price: 89,
      imageUrl:
          'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=500&h=500&fit=crop',
      description:
          'Interactive baby rocker. Features music, lights, and gentle rocking motion for newborns.',
      availableColors: ['Multi'],
      availableSizes: ['One Size'],
      brand: 'Fisher-Price',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // LEGO Collection
    Product(
      id: '132',
      name: 'LEGO Classic Brick Building Set',
      price: 59,
      imageUrl:
          'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=500&h=500&fit=crop',
      description:
          'Creative LEGO set with 900 colorful bricks. Perfect for ages 4+. Endless building possibilities.',
      availableColors: ['Multi'],
      availableSizes: ['One Size'],
      brand: 'LEGO',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    // Pampers Diapers Collection
    Product(
      id: '133',
      name: 'Pampers Swaddlers Diapers (Size 2)',
      price: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=500&h=500&fit=crop',
      description:
          'Premium baby diapers. Ultra-soft with wetness protection. Pack of 132 diapers.',
      availableColors: ['White'],
      availableSizes: ['Size 2 (6-15 lbs)'],
      brand: 'Pampers',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ PET SUPPLIES ============

    // Royal Canin Pet Food Collection
    Product(
      id: '134',
      name: 'Royal Canin Small Dog Adult Food',
      price: 42,
      imageUrl:
          'https://images.unsplash.com/photo-1568643692712-cff7faf96b77?w=500&h=500&fit=crop',
      description:
          'Premium dog food for small breeds. Balanced nutrition for optimal health. 1.5kg bag.',
      availableColors: ['Brown'],
      availableSizes: ['1.5kg', '3kg', '8kg'],
      brand: 'Royal Canin',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Kong Pet Toys Collection
    Product(
      id: '135',
      name: 'KONG Classic Dog Toy',
      price: 15,
      imageUrl:
          'https://images.unsplash.com/photo-1568643692712-cff7faf96b77?w=500&h=500&fit=crop',
      description:
          'Durable rubber dog toy. Can be stuffed with treats. Recommended by veterinarians worldwide.',
      availableColors: ['Red', 'Black'],
      availableSizes: ['Small', 'Medium', 'Large'],
      brand: 'KONG',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    // Whiskas Cat Food Collection
    Product(
      id: '136',
      name: 'Whiskas Cat Food Variety Pack',
      price: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1568643692712-cff7faf96b77?w=500&h=500&fit=crop',
      description:
          'Variety pack with multiple flavors. Balanced nutrition for adult cats. 24 pouches.',
      availableColors: ['Multi'],
      availableSizes: ['24x85g'],
      brand: 'Whiskas',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Petmate Pet Crate Collection
    Product(
      id: '137',
      name: 'Petmate Traditional Pet Crate',
      price: 79,
      imageUrl:
          'https://images.unsplash.com/photo-1568643692712-cff7faf96b77?w=500&h=500&fit=crop',
      description:
          'Durable plastic pet crate with secure door. Well-ventilated for safe pet transport.',
      availableColors: ['Black', 'White', 'Blue'],
      availableSizes: ['Small', 'Medium', 'Large', 'XLarge'],
      brand: 'Petmate',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ ADDITIONAL CLOTHING & FASHION ============

    // Designer Dresses & Formal Wear
    Product(
      id: '138',
      name: 'Zara Wrap Midi Dress',
      price: 89,
      imageUrl:
          'https://images.unsplash.com/photo-1595777707802-08d375a01415?w=500&h=500&fit=crop',
      description:
          'Elegant wrap midi dress. Perfect for professional settings and casual outings. Easy to style with any accessories.',
      availableColors: ['Black', 'White', 'Navy', 'Red'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      brand: 'Zara',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // Eyewear Collection
    Product(
      id: '139',
      name: 'Ray-Ban Aviator Sunglasses',
      price: 154,
      imageUrl:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&h=500&fit=crop',
      description:
          'Classic aviator sunglasses with UV protection. Timeless style that works for any season.',
      availableColors: ['Gold/Brown', 'Silver/Blue', 'Gun/Grey'],
      availableSizes: ['One Size'],
      brand: 'Ray-Ban',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Scarves & Accessories
    Product(
      id: '140',
      name: 'Burberry Check Silk Scarf',
      price: 395,
      imageUrl:
          'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500&h=500&fit=crop',
      description:
          'Premium silk scarf with iconic Burberry check pattern. Versatile accessory for any wardrobe.',
      availableColors: ['Classic Beige', 'Navy', 'Burgundy'],
      availableSizes: ['One Size'],
      brand: 'Burberry',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // Jewelry Collection
    Product(
      id: '141',
      name: 'Tiffany & Co. Diamond Ring',
      price: 1895,
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500&h=500&fit=crop',
      description:
          'Elegant diamond solitaire engagement ring. Premium quality with certificate of authenticity.',
      availableColors: ['White Gold', 'Yellow Gold', 'Rose Gold'],
      availableSizes: ['5', '6', '7', '8', '9', '10'],
      brand: 'Tiffany & Co.',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ SMARTPHONES & TABLETS ============
    Product(
      id: '142',
      name: 'iPhone 15 Pro Max',
      price: 1199,
      imageUrl:
          'https://images.unsplash.com/photo-1592286927505-1def25115558?w=500&h=500&fit=crop',
      description:
          'Latest iPhone with advanced camera system and A17 Pro chip. Superior performance and design.',
      availableColors: ['Black', 'White', 'Blue', 'Titanium'],
      availableSizes: ['One Size'],
      brand: 'Apple',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '143',
      name: 'Samsung Galaxy Tab S9',
      price: 799,
      imageUrl:
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500&h=500&fit=crop',
      description:
          'Premium tablet with stunning AMOLED display. Perfect for productivity and entertainment.',
      availableColors: ['Graphite', 'Silver', 'Beige'],
      availableSizes: ['One Size'],
      brand: 'Samsung',
      discount: 12,
      category: ProductCategory.footwear,
    ),

    // ============ LAPTOPS & COMPUTERS ============
    Product(
      id: '144',
      name: 'MacBook Pro 14-inch M3',
      price: 1999,
      imageUrl:
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&h=500&fit=crop',
      description:
          'Powerful laptop for professionals. Advanced M3 chip with excellent battery life.',
      availableColors: ['Space Grey', 'Silver'],
      availableSizes: ['One Size'],
      brand: 'Apple',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '145',
      name: 'Dell XPS 13 Laptop',
      price: 1299,
      imageUrl:
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&h=500&fit=crop',
      description:
          'Ultra-slim laptop with powerful Intel processor. Perfect for work and creative tasks.',
      availableColors: ['Silver', 'Midnight'],
      availableSizes: ['One Size'],
      brand: 'Dell',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ BEDROOM & BEDDING ============
    Product(
      id: '146',
      name: 'Brooklinen Luxe Sheets (Queen)',
      price: 249,
      imageUrl:
          'https://images.unsplash.com/photo-1520704303104-fc0fef534d27?w=500&h=500&fit=crop',
      description:
          'Premium Egyptian cotton sheets. Ultra-soft with deep pockets. Set includes 2 pillowcases.',
      availableColors: ['White', 'Slate', 'Charcoal', 'Sage'],
      availableSizes: ['Twin', 'Queen', 'King'],
      brand: 'Brooklinen',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '147',
      name: 'Casper Original Mattress (Queen)',
      price: 1095,
      imageUrl:
          'https://images.unsplash.com/photo-1563229841-46f09d8acb57?w=500&h=500&fit=crop',
      description:
          'All-foam mattress with perfect balance of comfort and support. 100-night sleep trial.',
      availableColors: ['White'],
      availableSizes: ['Twin', 'Full', 'Queen', 'King'],
      brand: 'Casper',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ FURNITURE ============
    Product(
      id: '148',
      name: 'West Elm Mid-Century Sofa',
      price: 1599,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop',
      description:
          'Stylish mid-century modern sofa. Comfortable seating for families. Available in multiple fabrics.',
      availableColors: ['Granite', 'Saddle', 'Fog'],
      availableSizes: ['One Size'],
      brand: 'West Elm',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '149',
      name: 'Steelcase Task Chair',
      price: 699,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&h=500&fit=crop',
      description:
          'Ergonomic office chair. Perfect posture support for long work hours. Adjustable everything.',
      availableColors: ['Black', 'Grey', 'Navy'],
      availableSizes: ['One Size'],
      brand: 'Steelcase',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // ============ KITCHEN & DINING ============
    Product(
      id: '150',
      name: 'KitchenAid Stand Mixer',
      price: 329,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d782a?w=500&h=500&fit=crop',
      description:
          'Professional mixer for baking and cooking. 10-speed settings with 5-quart stainless bowl.',
      availableColors: ['White', 'Red', 'Black', 'Ice Blue'],
      availableSizes: ['One Size'],
      brand: 'KitchenAid',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '151',
      name: 'Instant Pot Duo Pressure Cooker',
      price: 99,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d782a?w=500&h=500&fit=crop',
      description:
          'Multi-function pressure cooker. Makes cooking faster and easier. 7-in-1 functionality.',
      availableColors: ['Stainless Steel'],
      availableSizes: ['6-Quart'],
      brand: 'Instant Pot',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '152',
      name: 'Zwilling J.A. Henckels Knife Set',
      price: 449,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d782a?w=500&h=500&fit=crop',
      description:
          'Premium German kitchen knives. 4-piece set with leather storage block. Professional quality.',
      availableColors: ['Silver'],
      availableSizes: ['4-Piece Set'],
      brand: 'Zwilling J.A. Henckels',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ HOME DÉCOR ============
    Product(
      id: '153',
      name: 'Modern Canvas Wall Art (Set of 3)',
      price: 149,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d782a?w=500&h=500&fit=crop',
      description:
          'Trendy abstract wall art. Ready to hang. Adds personality to any room.',
      availableColors: ['Black/White', 'Blue/Grey', 'Gold/Black'],
      availableSizes: ['One Size'],
      brand: 'Art & Home',
      discount: 20,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '154',
      name: 'Marble Table Lamp',
      price: 189,
      imageUrl:
          'https://images.unsplash.com/photo-1565636192335-14e9edc7d3e0?w=500&h=500&fit=crop',
      description:
          'Elegant marble table lamp with brass details. Perfect ambient lighting for any room.',
      availableColors: ['White Marble', 'Black Marble'],
      availableSizes: ['One Size'],
      brand: 'Modern Living',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ MAKEUP & COSMETICS ============
    Product(
      id: '155',
      name: 'Urban Decay Naked Palette',
      price: 54,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Premium eyeshadow palette with 12 versatile nude shades. Long-lasting and blendable.',
      availableColors: ['Original'],
      availableSizes: ['One Size'],
      brand: 'Urban Decay',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '156',
      name: 'Charlotte Tilbury Lipstick',
      price: 36,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&h=500&fit=crop',
      description:
          'Luxury lipstick with rich, saturated color. Long-wearing formula with comfortable feel.',
      availableColors: [
        'Red Carpet Red',
        'Red Carpet Black',
        'Red Carpet Pink',
      ],
      availableSizes: ['One Size'],
      brand: 'Charlotte Tilbury',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    // ============ HAIRCARE PRODUCTS ============
    Product(
      id: '157',
      name: 'GHD Gold Professional Straightener',
      price: 199,
      imageUrl:
          'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=500&h=500&fit=crop',
      description:
          'Professional hair straightener. Advanced technology for smooth, shiny hair. Dual zone technology.',
      availableColors: ['Black', 'White'],
      availableSizes: ['One Size'],
      brand: 'GHD',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ YOGA & FITNESS ACCESSORIES ============
    Product(
      id: '158',
      name: 'Manduka PRO Yoga Mat',
      price: 119,
      imageUrl:
          'https://images.unsplash.com/photo-1594737177126-cfe83ae6e2e2?w=500&h=500&fit=crop',
      description:
          'Professional yoga mat made from natural rubber. 6mm thickness with excellent cushioning.',
      availableColors: ['Black', 'Purple', 'Blue', 'Sage'],
      availableSizes: ['One Size'],
      brand: 'Manduka',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    Product(
      id: '159',
      name: 'Lululemon ABC Pants',
      price: 128,
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=500&h=500&fit=crop',
      description:
          'Versatile athletic pants for any activity. Stretchy fabric with hidden pockets.',
      availableColors: ['Black', 'Navy', 'Khaki', 'Stone'],
      availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
      brand: 'Lululemon',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // ============ OUTDOOR GEAR ============
    Product(
      id: '160',
      name: 'The North Face Thermoball Tent',
      price: 349,
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=500&h=500&fit=crop',
      description:
          'Lightweight camping tent. Fits 2 people comfortably. Easy setup with excellent weather protection.',
      availableColors: ['Green', 'Blue', 'Grey'],
      availableSizes: ['2-Person', '3-Person'],
      brand: 'The North Face',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    Product(
      id: '161',
      name: 'Coleman Camping Sleeping Bag',
      price: 69,
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=500&h=500&fit=crop',
      description:
          'Comfortable sleeping bag for all seasons. Temperature rated to -10°C. Easy to pack.',
      availableColors: ['Green', 'Grey', 'Blue'],
      availableSizes: ['One Size'],
      brand: 'Coleman',
      discount: 12,
      category: ProductCategory.sportswear,
    ),

    // ============ BICYCLES & CYCLING ============
    Product(
      id: '162',
      name: 'Trek Marlin Mountain Bike',
      price: 599,
      imageUrl:
          'https://images.unsplash.com/photo-1487180144351-b8472da7d491?w=500&h=500&fit=crop',
      description:
          'Entry-level mountain bike. Perfect for trails and casual riding. Aluminum frame.',
      availableColors: ['Red', 'Blue', 'Black'],
      availableSizes: ['Small', 'Medium', 'Large'],
      brand: 'Trek',
      discount: 0,
      category: ProductCategory.sportswear,
    ),

    // ============ GAMING & ENTERTAINMENT ============
    Product(
      id: '163',
      name: 'PlayStation 5 Console',
      price: 499,
      imageUrl:
          'https://images.unsplash.com/photo-1605559424843-9e4c3dec3106?w=500&h=500&fit=crop',
      description:
          'Latest gaming console with 4K gaming. Includes DualSense controller and HDMI cable.',
      availableColors: ['White'],
      availableSizes: ['One Size'],
      brand: 'PlayStation',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '164',
      name: 'Nintendo Switch OLED',
      price: 349,
      imageUrl:
          'https://images.unsplash.com/photo-1605559424843-9e4c3dec3106?w=500&h=500&fit=crop',
      description:
          'Portable gaming console with vibrant OLED screen. Play anywhere, anytime.',
      availableColors: ['White', 'Black'],
      availableSizes: ['One Size'],
      brand: 'Nintendo',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ PREMIUM WINE & BEVERAGES ============
    Product(
      id: '165',
      name: 'Dom Pérignon Champagne 2012',
      price: 189,
      imageUrl:
          'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=500&h=500&fit=crop',
      description:
          'Premium champagne with complex flavor profile. Perfect for celebrations and special occasions.',
      availableColors: ['Gold'],
      availableSizes: ['750ml'],
      brand: 'Dom Pérignon',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ SPECIALTY FOOD ITEMS ============
    Product(
      id: '166',
      name: 'Ferrero Rocher Premium Chocolates',
      price: 32,
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-51c6662a9a6d?w=500&h=500&fit=crop',
      description:
          'Luxury chocolate assortment. 48 pieces of hazelnut and wafer delights.',
      availableColors: ['Gold'],
      availableSizes: ['1.6kg'],
      brand: 'Ferrero Rocher',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ SUBSCRIPTIONS & DIGITAL ============
    Product(
      id: '167',
      name: 'Spotify Premium - 3 Month Subscription',
      price: 29.97,
      imageUrl:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500&h=500&fit=crop',
      description:
          'Ad-free music streaming. Unlimited skips and offline listening. 3-month subscription.',
      availableColors: ['Digital'],
      availableSizes: ['One Size'],
      brand: 'Spotify',
      discount: 10,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '168',
      name: 'Netflix Premium - Annual Plan',
      price: 159.99,
      imageUrl:
          'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=500&h=500&fit=crop',
      description:
          'Unlimited movies and TV shows. 4K quality with HDR. Watch on 4 screens simultaneously.',
      availableColors: ['Digital'],
      availableSizes: ['One Size'],
      brand: 'Netflix',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ SMARTWATCH & WEARABLES ============
    Product(
      id: '169',
      name: 'Fitbit Charge 6 Fitness Tracker',
      price: 199,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
      description:
          'Advanced fitness tracker with health monitoring. Track heart rate, sleep, workouts.',
      availableColors: ['Black', 'Gold', 'Silver'],
      availableSizes: ['S', 'L'],
      brand: 'Fitbit',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ TRAVEL & LUGGAGE ============
    Product(
      id: '170',
      name: 'Rimowa Essential Cabin Luggage',
      price: 345,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      description:
          'Premium carry-on luggage. Lightweight polycarbonate shell with TSA-approved lock.',
      availableColors: ['Black', 'Cactus Green', 'Titanium'],
      availableSizes: ['One Size'],
      brand: 'Rimowa',
      discount: 0,
      category: ProductCategory.footwear,
    ),

    // ============ HOME AUTOMATION ============
    Product(
      id: '171',
      name: 'Google Nest Hub Max',
      price: 229,
      imageUrl:
          'https://images.unsplash.com/photo-1558089120-d5df44dc6f20?w=500&h=500&fit=crop',
      description:
          'Smart display with video calling. Control smart home devices with voice commands.',
      availableColors: ['Chalk', 'Charcoal'],
      availableSizes: ['One Size'],
      brand: 'Google',
      discount: 15,
      category: ProductCategory.footwear,
    ),

    Product(
      id: '172',
      name: 'Amazon Echo Dot (5th Gen)',
      price: 49,
      imageUrl:
          'https://images.unsplash.com/photo-1518222308034-6461029ca189?w=500&h=500&fit=crop',
      description:
          'Compact smart speaker. Control smart home, play music, ask questions with Alexa.',
      availableColors: ['Charcoal', 'White', 'Blue'],
      availableSizes: ['One Size'],
      brand: 'Amazon',
      discount: 20,
      category: ProductCategory.footwear,
    ),
  ];

  /// Get product by ID
  static Product getProductById(String id) {
    return products.firstWhere(
      (product) => product.id == id,
      orElse: () => products[0],
    );
  }

  /// Get products by brand
  static List<Product> getProductsByBrand(String brand) {
    return products.where((product) => product.brand == brand).toList();
  }

  /// Get products by category
  static List<Product> getProductsByCategory(String category) {
    return products
        .where(
          (product) =>
              product.category.toString().split('.')[1].toLowerCase() ==
              category.toLowerCase(),
        )
        .toList();
  }

  /// Get featured products (products with discount)
  static List<Product> getFeaturedProducts() {
    return products.where((product) => (product.discount ?? 0) > 0).toList();
  }

  /// Get all brands
  static List<String> getAllBrands() {
    return products.map((product) => product.brand).toSet().toList()..sort();
  }

  /// Get all categories
  static List<String> getAllCategories() {
    return products
        .map((product) => product.category.toString().split('.')[1])
        .toSet()
        .toList()
      ..sort();
  }

  /// Get category products count
  static int getCategoryCount(String category) {
    return products
        .where(
          (product) =>
              product.category.toString().split('.')[1].toLowerCase() ==
              category.toLowerCase(),
        )
        .length;
  }
}
