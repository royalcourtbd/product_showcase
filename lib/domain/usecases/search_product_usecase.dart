import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class SearchProductsUseCase extends BaseUseCase<ProductListEntity> {
  final ProductRepository _productRepository;

  SearchProductsUseCase(
    this._productRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, ProductListEntity>> execute(String query) async {
    return await mapResultToEither(() async {
      if (query.isEmpty) {
        // If query is empty, return all products
        final result = await _productRepository.getProducts();
        return result.getRight().getOrElse(
          () => throw Exception('Failed to get products'),
        );
      }

      final result = await _productRepository.searchProducts(query);
      return result.getRight().getOrElse(
        () => throw Exception('Failed to search products'),
      );
    });
  }
}
