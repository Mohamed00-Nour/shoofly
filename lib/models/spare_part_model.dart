enum PartCondition { brand_new, used_like_new, used_good, used_fair, refurbished }

enum UrgencyLevel { normal, urgent, emergency }

enum RequestStatus { 
  submitted, 
  searching, 
  quotes_received, 
  quote_accepted, 
  order_confirmed, 
  processing, 
  out_for_delivery, 
  delivered, 
  cancelled 
}

class SparePart {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? subCategory;
  final String? brand;
  final String? model;
  final String? year;
  final String? partNumber;
  final PartCondition condition;
  final double price;
  final String currency;
  final List<String> images;
  final String storeId;
  final String storeName;
  final bool isAvailable;
  final int stockQuantity;
  final String? warranty;
  final Map<String, dynamic>? specifications;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SparePart({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.subCategory,
    this.brand,
    this.model,
    this.year,
    this.partNumber,
    required this.condition,
    required this.price,
    this.currency = 'USD',
    this.images = const [],
    required this.storeId,
    required this.storeName,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.warranty,
    this.specifications,
    required this.createdAt,
    this.updatedAt,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['sub_category'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      partNumber: json['part_number'],
      condition: _parseCondition(json['condition']),
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name'] ?? '',
      isAvailable: json['is_available'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
      warranty: json['warranty'],
      specifications: json['specifications'] is Map<String, dynamic> 
          ? json['specifications'] as Map<String, dynamic>
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  static PartCondition _parseCondition(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'brand_new':
        return PartCondition.brand_new;
      case 'used_like_new':
        return PartCondition.used_like_new;
      case 'used_good':
        return PartCondition.used_good;
      case 'used_fair':
        return PartCondition.used_fair;
      case 'refurbished':
        return PartCondition.refurbished;
      default:
        return PartCondition.used_good;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'sub_category': subCategory,
      'brand': brand,
      'model': model,
      'year': year,
      'part_number': partNumber,
      'condition': condition.name,
      'price': price,
      'currency': currency,
      'images': images,
      'store_id': storeId,
      'store_name': storeName,
      'is_available': isAvailable,
      'stock_quantity': stockQuantity,
      'warranty': warranty,
      'specifications': specifications,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get conditionDisplayName {
    switch (condition) {
      case PartCondition.brand_new:
        return 'Brand New';
      case PartCondition.used_like_new:
        return 'Used - Like New';
      case PartCondition.used_good:
        return 'Used - Good';
      case PartCondition.used_fair:
        return 'Used - Fair';
      case PartCondition.refurbished:
        return 'Refurbished';
    }
  }

  @override
  String toString() {
    return 'SparePart{id: $id, name: $name, price: \$${price.toStringAsFixed(2)}, condition: $conditionDisplayName}';
  }
}

class SparePartRequest {
  final String id;
  final String userId;
  final String description;
  final List<String> images;
  final String category;
  final String? brand;
  final String? model;
  final String? year;
  final double minPrice;
  final double maxPrice;
  final String currency;
  final UrgencyLevel urgency;
  final RequestStatus status;
  final double? userLatitude;
  final double? userLongitude;
  final String? userAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<PartQuote> quotes;

  SparePartRequest({
    required this.id,
    required this.userId,
    required this.description,
    this.images = const [],
    required this.category,
    this.brand,
    this.model,
    this.year,
    required this.minPrice,
    required this.maxPrice,
    this.currency = 'USD',
    required this.urgency,
    required this.status,
    this.userLatitude,
    this.userLongitude,
    this.userAddress,
    required this.createdAt,
    this.updatedAt,
    this.quotes = const [],
  });

  factory SparePartRequest.fromJson(Map<String, dynamic> json) {
    return SparePartRequest(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      category: json['category'] ?? '',
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      minPrice: (json['min_price'] ?? 0.0).toDouble(),
      maxPrice: (json['max_price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      urgency: _parseUrgency(json['urgency']),
      status: _parseStatus(json['status']),
      userLatitude: json['user_latitude']?.toDouble(),
      userLongitude: json['user_longitude']?.toDouble(),
      userAddress: json['user_address'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      quotes: json['quotes'] != null 
          ? (json['quotes'] as List).map((q) => PartQuote.fromJson(q)).toList()
          : [],
    );
  }

  static UrgencyLevel _parseUrgency(String? urgency) {
    switch (urgency?.toLowerCase()) {
      case 'urgent':
        return UrgencyLevel.urgent;
      case 'emergency':
        return UrgencyLevel.emergency;
      default:
        return UrgencyLevel.normal;
    }
  }

  static RequestStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'submitted':
        return RequestStatus.submitted;
      case 'searching':
        return RequestStatus.searching;
      case 'quotes_received':
        return RequestStatus.quotes_received;
      case 'quote_accepted':
        return RequestStatus.quote_accepted;
      case 'order_confirmed':
        return RequestStatus.order_confirmed;
      case 'processing':
        return RequestStatus.processing;
      case 'out_for_delivery':
        return RequestStatus.out_for_delivery;
      case 'delivered':
        return RequestStatus.delivered;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.submitted;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'images': images,
      'category': category,
      'brand': brand,
      'model': model,
      'year': year,
      'min_price': minPrice,
      'max_price': maxPrice,
      'currency': currency,
      'urgency': urgency.name,
      'status': status.name,
      'user_latitude': userLatitude,
      'user_longitude': userLongitude,
      'user_address': userAddress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'quotes': quotes.map((q) => q.toJson()).toList(),
    };
  }

  String get urgencyDisplayName {
    switch (urgency) {
      case UrgencyLevel.normal:
        return 'Normal';
      case UrgencyLevel.urgent:
        return 'Urgent';
      case UrgencyLevel.emergency:
        return 'Emergency';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case RequestStatus.submitted:
        return 'Request Submitted';
      case RequestStatus.searching:
        return 'Searching Stores';
      case RequestStatus.quotes_received:
        return 'Quotes Received';
      case RequestStatus.quote_accepted:
        return 'Quote Accepted';
      case RequestStatus.order_confirmed:
        return 'Order Confirmed';
      case RequestStatus.processing:
        return 'Processing';
      case RequestStatus.out_for_delivery:
        return 'Out for Delivery';
      case RequestStatus.delivered:
        return 'Delivered';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  String toString() {
    return 'SparePartRequest{id: $id, status: $statusDisplayName, quotes: ${quotes.length}}';
  }
}

class PartQuote {
  final String id;
  final String requestId;
  final String storeId;
  final String storeName;
  final String sparePartId;
  final SparePart sparePart;
  final double quotedPrice;
  final String currency;
  final String? notes;
  final int estimatedDeliveryDays;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? expiresAt;

  PartQuote({
    required this.id,
    required this.requestId,
    required this.storeId,
    required this.storeName,
    required this.sparePartId,
    required this.sparePart,
    required this.quotedPrice,
    this.currency = 'USD',
    this.notes,
    this.estimatedDeliveryDays = 1,
    this.isAvailable = true,
    required this.createdAt,
    this.expiresAt,
  });

  factory PartQuote.fromJson(Map<String, dynamic> json) {
    return PartQuote(
      id: json['id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name'] ?? '',
      sparePartId: json['spare_part_id']?.toString() ?? '',
      sparePart: SparePart.fromJson(json['spare_part'] ?? {}),
      quotedPrice: (json['quoted_price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      notes: json['notes'],
      estimatedDeliveryDays: json['estimated_delivery_days'] ?? 1,
      isAvailable: json['is_available'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null 
          ? DateTime.tryParse(json['expires_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'store_id': storeId,
      'store_name': storeName,
      'spare_part_id': sparePartId,
      'spare_part': sparePart.toJson(),
      'quoted_price': quotedPrice,
      'currency': currency,
      'notes': notes,
      'estimated_delivery_days': estimatedDeliveryDays,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  String toString() {
    return 'PartQuote{id: $id, store: $storeName, price: \$${quotedPrice.toStringAsFixed(2)}}';
  }
}
