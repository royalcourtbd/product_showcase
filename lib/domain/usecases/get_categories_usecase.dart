import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class GetCategoriesUseCase extends BaseUseCase<List<String>> {
  final ProductRepository _productRepository;

  GetCategoriesUseCase(
    this._productRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, List<String>>> execute() async {
    return await mapResultToEither(() async {
      final result = await _productRepository.getCategories();
      return result.getRight().getOrElse(
        () => throw Exception('Failed to get categories'),
      );
    });
  }
}
