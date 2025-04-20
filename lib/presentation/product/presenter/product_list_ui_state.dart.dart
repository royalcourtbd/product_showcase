import 'package:initial_project/core/base/base_ui_state.dart';
import 'package:initial_project/domain/entities/product_entity.dart';

class ProductListUiState extends BaseUiState {
  final List<ProductEntity> products;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final bool isSearching;

  const ProductListUiState({
    required super.isLoading,
    required super.userMessage,
    required this.products,
    required this.categories,
    this.selectedCategory,
    required this.searchQuery,
    required this.isSearching,
  });

  factory ProductListUiState.empty() {
    return const ProductListUiState(
      isLoading: false,
      userMessage: null,
      products: [],
      categories: [],
      selectedCategory: null,
      searchQuery: '',
      isSearching: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    products,
    categories,
    selectedCategory,
    searchQuery,
    isSearching,
  ];

  ProductListUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool? isSearching,
  }) {
    return ProductListUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
