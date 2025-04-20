import 'package:initial_project/core/base/base_ui_state.dart';
import 'package:initial_project/domain/entities/product_entity.dart';

class ProductDetailUiState extends BaseUiState {
  final ProductEntity? product;

  const ProductDetailUiState({
    required super.isLoading,
    required super.userMessage,
    this.product,
  });

  factory ProductDetailUiState.empty() {
    return const ProductDetailUiState(
      isLoading: false,
      userMessage: null,
      product: null,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, product];

  ProductDetailUiState copyWith({
    bool? isLoading,
    String? userMessage,
    ProductEntity? product,
  }) {
    return ProductDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      product: product ?? this.product,
    );
  }
}
