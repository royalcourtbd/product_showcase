import 'package:fpdart/fpdart.dart';
import 'package:initial_project/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<String, ProductListEntity>> getProducts({int limit = 100});

  Future<Either<String, ProductListEntity>> searchProducts(String query);

  Future<Either<String, List<String>>> getCategories();

  Future<Either<String, ProductListEntity>> getProductsByCategory(
    String categoryName,
  );

  Future<Either<String, ProductEntity>> getProductDetails(int id);
}
