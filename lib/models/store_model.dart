class Store {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? email;
  final String? website;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final StoreHours hours;
  final List<String> specialties;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? distanceFromUser; // in kilometers

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.email,
    this.website,
    this.images = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.hours,
    this.specialties = const [],
    this.isActive = true,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.distanceFromUser,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'],
      website: json['website'],
      images: json['images'] != null 
          ? List<String>.from(json['images'])
          : [],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      hours: StoreHours.fromJson(json['hours'] ?? {}),
      specialties: json['specialties'] != null 
          ? List<String>.from(json['specialties'])
          : [],
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      distanceFromUser: json['distance_from_user']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'website': website,
      'images': images,
      'rating': rating,
      'review_count': reviewCount,
      'hours': hours.toJson(),
      'specialties': specialties,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'distance_from_user': distanceFromUser,
    };
  }

  Store copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    List<String>? images,
    double? rating,
    int? reviewCount,
    StoreHours? hours,
    List<String>? specialties,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distanceFromUser,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      hours: hours ?? this.hours,
      specialties: specialties ?? this.specialties,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
    );
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, rating: $rating, distance: ${distanceFromUser}km}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class StoreHours {
  final Map<String, DayHours> weeklyHours;

  StoreHours({required this.weeklyHours});

  factory StoreHours.fromJson(Map<String, dynamic> json) {
    Map<String, DayHours> hours = {};
    
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    
    for (String day in days) {
      if (json[day] != null) {
        hours[day] = DayHours.fromJson(json[day]);
      } else {
        hours[day] = DayHours.closed();
      }
    }
    
    return StoreHours(weeklyHours: hours);
  }

  Map<String, dynamic> toJson() {
    return weeklyHours.map((key, value) => MapEntry(key, value.toJson()));
  }

  DayHours? getHoursForDay(String day) {
    return weeklyHours[day.toLowerCase()];
  }

  bool isOpenOnDay(String day) {
    final dayHours = getHoursForDay(day);
    return dayHours?.isOpen ?? false;
  }
}

class DayHours {
  final bool isOpen;
  final String? openTime;  // Format: "09:00"
  final String? closeTime; // Format: "18:00"

  DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) {
    return DayHours(
      isOpen: json['is_open'] ?? false,
      openTime: json['open_time'],
      closeTime: json['close_time'],
    );
  }

  factory DayHours.closed() {
    return DayHours(isOpen: false);
  }

  factory DayHours.open(String openTime, String closeTime) {
    return DayHours(
      isOpen: true,
      openTime: openTime,
      closeTime: closeTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
    };
  }

  @override
  String toString() {
    if (!isOpen) return 'Closed';
    return '$openTime - $closeTime';
  }
}

// Store review model
class StoreReview {
  final String id;
  final String storeId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  StoreReview({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });

  factory StoreReview.fromJson(Map<String, dynamic> json) {
    return StoreReview(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'images': images,
    };
  }
}
