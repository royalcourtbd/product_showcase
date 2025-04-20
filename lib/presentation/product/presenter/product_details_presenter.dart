import 'package:initial_project/core/base/base_presenter.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/domain/usecases/get_product_details_usecase.dart';
import 'package:initial_project/presentation/product/presenter/product_detail_ui_state.dart';

class ProductDetailPresenter extends BasePresenter<ProductDetailUiState> {
  final Obs<ProductDetailUiState> uiState = Obs<ProductDetailUiState>(
    ProductDetailUiState.empty(),
  );
  ProductDetailUiState get currentUiState => uiState.value;

  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailPresenter(this._getProductDetailsUseCase);

  Future<void> loadProductDetails(int productId) async {
    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage(
        task: () => _getProductDetailsUseCase.execute(productId),
        onDataLoaded: (product) {
          uiState.value = currentUiState.copyWith(product: product);
        },
      );
    });
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
