/// User model for profile data
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String membershipTier; // 'Bronze', 'Silver', 'Gold', 'Platinum'
  final int loyaltyPoints;
  final int totalOrders;
  final int totalReviews;
  final double walletBalance;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.membershipTier = 'Bronze',
    this.loyaltyPoints = 0,
    this.totalOrders = 0,
    this.totalReviews = 0,
    this.walletBalance = 0.0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? membershipTier,
    int? loyaltyPoints,
    int? totalOrders,
    int? totalReviews,
    double? walletBalance,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membershipTier: membershipTier ?? this.membershipTier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      totalOrders: totalOrders ?? this.totalOrders,
      totalReviews: totalReviews ?? this.totalReviews,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
