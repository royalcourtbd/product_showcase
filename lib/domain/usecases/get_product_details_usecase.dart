import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class GetProductDetailsUseCase extends BaseUseCase<ProductEntity> {
  final ProductRepository _productRepository;

  GetProductDetailsUseCase(
    this._productRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, ProductEntity>> execute(int id) async {
    return await mapResultToEither(() async {
      final result = await _productRepository.getProductDetails(id);
      return result.getRight().getOrElse(
        () => throw Exception('Failed to get product details'),
      );
    });
  }
}
