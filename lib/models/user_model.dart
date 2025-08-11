class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? address;
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.address,
    this.preferences,
  });

  // Convert from JSON (from API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profile_image'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      isActive: json['is_active'] ?? true,
      address: json['address'],
      preferences: json['preferences'] is Map<String, dynamic> 
          ? json['preferences'] as Map<String, dynamic>
          : null,
    );
  }

  // Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'address': address,
      'preferences': preferences,
    };
  }

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? address,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      address: address ?? this.address,
      preferences: preferences ?? this.preferences,
    );
  }

  // For debugging and logging
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

// User authentication data model
class UserAuth {
  final String email;
  final String password;
  final String? name;
  final String? phone;

  UserAuth({
    required this.email,
    required this.password,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
    };
  }
}

// User login response model
class LoginResponse {
  final User user;
  final String token;
  final String tokenType;
  final DateTime expiresAt;

  LoginResponse({
    required this.user,
    required this.token,
    this.tokenType = 'Bearer',
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? 
          DateTime.now().add(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'token_type': tokenType,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
