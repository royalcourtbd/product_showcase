import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/utility/trial_utility.dart';
import 'package:initial_project/data/datasources/remote/product_remote_data_source.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  ProductRepositoryImpl(
    this._productRemoteDataSource,
    this._errorMessageHandler,
  );

  @override
  Future<Either<String, ProductListEntity>> getProducts({
    int limit = 100,
  }) async {
    return await catchAndReturnFuture<Either<String, ProductListEntity>>(
          () async {
            final productList = await _productRemoteDataSource.getProducts(
              limit: limit,
            );
            return right(productList);
          },
        ) ??
        left(
          _errorMessageHandler.generateErrorMessage("Error getting products"),
        );
  }

  @override
  Future<Either<String, ProductListEntity>> searchProducts(String query) async {
    return await catchAndReturnFuture<Either<String, ProductListEntity>>(
          () async {
            final productList = await _productRemoteDataSource.searchProducts(
              query,
            );
            return right(productList);
          },
        ) ??
        left(
          _errorMessageHandler.generateErrorMessage("Error searching products"),
        );
  }

  @override
  Future<Either<String, List<String>>> getCategories() async {
    return await catchAndReturnFuture<Either<String, List<String>>>(() async {
          final categories = await _productRemoteDataSource.getCategories();
          return right(categories);
        }) ??
        left(
          _errorMessageHandler.generateErrorMessage("Error getting categories"),
        );
  }

  @override
  Future<Either<String, ProductListEntity>> getProductsByCategory(
    String categoryName,
  ) async {
    return await catchAndReturnFuture<Either<String, ProductListEntity>>(
          () async {
            final productList = await _productRemoteDataSource
                .getProductsByCategory(categoryName);
            return right(productList);
          },
        ) ??
        left(
          _errorMessageHandler.generateErrorMessage(
            "Error getting products by category",
          ),
        );
  }

  @override
  Future<Either<String, ProductEntity>> getProductDetails(int id) async {
    return await catchAndReturnFuture<Either<String, ProductEntity>>(() async {
          final product = await _productRemoteDataSource.getProductDetails(id);
          return right(product);
        }) ??
        left(
          _errorMessageHandler.generateErrorMessage(
            "Error getting product details",
          ),
        );
  }
}
