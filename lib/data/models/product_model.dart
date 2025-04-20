import 'package:initial_project/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.images,
    required super.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    price: json["price"]?.toDouble(),
    discountPercentage: json["discountPercentage"]?.toDouble(),
    rating: json["rating"]?.toDouble(),
    stock: json["stock"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    brand: json["brand"],
    sku: json["sku"],
    weight: json["weight"],
    dimensions: DimensionsModel.fromJson(json["dimensions"]),
    warrantyInformation: json["warrantyInformation"],
    shippingInformation: _mapShippingInformation(json["shippingInformation"]),
    availabilityStatus: _mapAvailabilityStatus(json["availabilityStatus"]),
    reviews: List<ReviewModel>.from(
      json["reviews"].map((x) => ReviewModel.fromJson(x)),
    ),
    returnPolicy: _mapReturnPolicy(json["returnPolicy"]),
    minimumOrderQuantity: json["minimumOrderQuantity"],
    meta: MetaModel.fromJson(json["meta"]),
    images: List<String>.from(json["images"].map((x) => x)),
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "brand": brand,
    "sku": sku,
    "weight": weight,
    "dimensions": (dimensions as DimensionsModel).toJson(),
    "warrantyInformation": warrantyInformation,
    "shippingInformation": _reverseMapShippingInformation(shippingInformation),
    "availabilityStatus": _reverseMapAvailabilityStatus(availabilityStatus),
    "reviews": List<dynamic>.from(
      reviews.map((x) => (x as ReviewModel).toJson()),
    ),
    "returnPolicy": _reverseMapReturnPolicy(returnPolicy),
    "minimumOrderQuantity": minimumOrderQuantity,
    "meta": (meta as MetaModel).toJson(),
    "images": List<dynamic>.from(images.map((x) => x)),
    "thumbnail": thumbnail,
  };

  static String _mapShippingInformation(String value) {
    final map = {
      "Ships in 1-2 business days": "Ships in 1-2 business days",
      "Ships in 1 month": "Ships in 1 month",
      "Ships in 1 week": "Ships in 1 week",
      "Ships in 2 weeks": "Ships in 2 weeks",
      "Ships in 3-5 business days": "Ships in 3-5 business days",
      "Ships overnight": "Ships overnight",
    };
    return map[value] ?? value;
  }

  static String _reverseMapShippingInformation(String value) {
    final map = {
      "Ships in 1-2 business days": "Ships in 1-2 business days",
      "Ships in 1 month": "Ships in 1 month",
      "Ships in 1 week": "Ships in 1 week",
      "Ships in 2 weeks": "Ships in 2 weeks",
      "Ships in 3-5 business days": "Ships in 3-5 business days",
      "Ships overnight": "Ships overnight",
    };
    final entry = map.entries.firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry("", ""),
    );
    return entry.key;
  }

  static String _mapAvailabilityStatus(String value) {
    final map = {
      "In Stock": "In Stock",
      "Low Stock": "Low Stock",
      "Out of Stock": "Out of Stock",
    };
    return map[value] ?? value;
  }

  static String _reverseMapAvailabilityStatus(String value) {
    final map = {
      "In Stock": "In Stock",
      "Low Stock": "Low Stock",
      "Out of Stock": "Out of Stock",
    };
    final entry = map.entries.firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry("", ""),
    );
    return entry.key;
  }

  static String _mapReturnPolicy(String value) {
    final map = {
      "No return policy": "No return policy",
      "30 days return policy": "30 days return policy",
      "60 days return policy": "60 days return policy",
      "7 days return policy": "7 days return policy",
      "90 days return policy": "90 days return policy",
    };
    return map[value] ?? value;
  }

  static String _reverseMapReturnPolicy(String value) {
    final map = {
      "No return policy": "No return policy",
      "30 days return policy": "30 days return policy",
      "60 days return policy": "60 days return policy",
      "7 days return policy": "7 days return policy",
      "90 days return policy": "90 days return policy",
    };
    final entry = map.entries.firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry("", ""),
    );
    return entry.key;
  }
}

class DimensionsModel extends DimensionsEntity {
  const DimensionsModel({
    required super.width,
    required super.height,
    required super.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) =>
      DimensionsModel(
        width: json["width"]?.toDouble(),
        height: json["height"]?.toDouble(),
        depth: json["depth"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
    "depth": depth,
  };
}

class MetaModel extends MetaEntity {
  const MetaModel({
    required super.createdAt,
    required super.updatedAt,
    required super.barcode,
    required super.qrCode,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) => MetaModel(
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    barcode: json["barcode"],
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "barcode": barcode,
    "qrCode": qrCode,
  };
}

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    rating: json["rating"],
    comment: json["comment"],
    date: DateTime.parse(json["date"]),
    reviewerName: json["reviewerName"],
    reviewerEmail: json["reviewerEmail"],
  );

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "comment": comment,
    "date": date.toIso8601String(),
    "reviewerName": reviewerName,
    "reviewerEmail": reviewerEmail,
  };
}

class ProductListModel extends ProductListEntity {
  const ProductListModel({
    required super.products,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        products: List<ProductModel>.from(
          json["products"].map((x) => ProductModel.fromJson(x)),
        ),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(
      products.map((x) => (x as ProductModel).toJson()),
    ),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}
