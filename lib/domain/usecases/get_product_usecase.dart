import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class GetProductsUseCase extends BaseUseCase<ProductListEntity> {
  final ProductRepository _productRepository;

  GetProductsUseCase(
    this._productRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, ProductListEntity>> execute({int limit = 100}) async {
    return await mapResultToEither(() async {
      final result = await _productRepository.getProducts(limit: limit);
      return result.getRight().getOrElse(
        () => throw Exception('Failed to get products'),
      );
    });
  }
}
