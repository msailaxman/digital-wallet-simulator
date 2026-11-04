// ==============================================================================
// EXPERIMENT 1: DART PROGRAMMING FUNDAMENTALS (OOP, Class, CopyWith)
// Represents the logged-in user profile with wallet identification.
// ==============================================================================

class UserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String walletId;
  final String bio;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.walletId,
    this.bio = 'B.Tech Student | Flutter Developer',
  });

  // copyWith method to allow immutable updates to the user profile
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? walletId,
    String? bio,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      walletId: walletId ?? this.walletId,
      bio: bio ?? this.bio,
    );
  }
}
