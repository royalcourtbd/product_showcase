import 'package:fpdart/fpdart.dart';
import 'package:initial_project/domain/entities/product_entity.dart';

abstract class ProductRepository {
  /// Get all products with optional limit
  Future<Either<String, ProductListEntity>> getProducts({int limit = 100});

  /// Search products by query
  Future<Either<String, ProductListEntity>> searchProducts(String query);

  /// Get all product categories
  Future<Either<String, List<String>>> getCategories();

  /// Get products by category
  Future<Either<String, ProductListEntity>> getProductsByCategory(
    String categoryName,
  );

  /// Get product details by ID
  Future<Either<String, ProductEntity>> getProductDetails(int id);
}
