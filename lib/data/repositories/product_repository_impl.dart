import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/utility/logger_utility.dart';
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
    try {
      final productList = await _productRemoteDataSource.getProducts(
        limit: limit,
      );
      return right(productList);
    } catch (error) {
      logError('Error getting products: $error');
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }

  @override
  Future<Either<String, ProductListEntity>> searchProducts(String query) async {
    try {
      final productList = await _productRemoteDataSource.searchProducts(query);
      return right(productList);
    } catch (error) {
      logError('Error searching products: $error');
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }

  @override
  Future<Either<String, List<String>>> getCategories() async {
    try {
      final categories = await _productRemoteDataSource.getCategories();
      return right(categories);
    } catch (error) {
      logError('Error getting categories: $error');
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }

  @override
  Future<Either<String, ProductListEntity>> getProductsByCategory(
    String categoryName,
  ) async {
    try {
      final productList = await _productRemoteDataSource.getProductsByCategory(
        categoryName,
      );
      return right(productList);
    } catch (error) {
      logError('Error getting products by category: $error');
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }

  @override
  Future<Either<String, ProductEntity>> getProductDetails(int id) async {
    try {
      final product = await _productRemoteDataSource.getProductDetails(id);
      return right(product);
    } catch (error) {
      logError('Error getting product details: $error');
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }
}
