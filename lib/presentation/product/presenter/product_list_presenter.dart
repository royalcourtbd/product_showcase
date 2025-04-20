import 'dart:async';
import 'dart:developer';
import 'package:initial_project/core/base/base_presenter.dart';
import 'package:initial_project/core/external_libs/throttle_service.dart';
import 'package:initial_project/core/utility/number_utility.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/domain/usecases/get_categories_usecase.dart';
import 'package:initial_project/domain/usecases/get_product_usecase.dart';
import 'package:initial_project/domain/usecases/get_products_by_category_usecase.dart';
import 'package:initial_project/domain/usecases/search_product_usecase.dart';
import 'package:initial_project/presentation/product/presenter/product_list_ui_state.dart.dart';

class ProductListPresenter extends BasePresenter<ProductListUiState> {
  final Obs<ProductListUiState> uiState = Obs<ProductListUiState>(
    ProductListUiState.empty(),
  );
  ProductListUiState get currentUiState => uiState.value;

  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final SearchProductsUseCase _searchProductsUseCase;

  ProductListPresenter(
    this._getProductsUseCase,
    this._getCategoriesUseCase,
    this._getProductsByCategoryUseCase,
    this._searchProductsUseCase,
  );

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await executeTaskWithLoading(() async {
      await Future.wait([loadProducts(), loadCategories()]);
    });
  }

  Future<void> loadProducts() async {
    await parseDataFromEitherWithUserMessage(
      task: () => _getProductsUseCase.execute(),
      onDataLoaded: (productList) {
        uiState.value = currentUiState.copyWith(products: productList.products);
      },
    );
  }

  Future<void> loadCategories() async {
    await parseDataFromEitherWithUserMessage(
      task: () => _getCategoriesUseCase.execute(),
      onDataLoaded: (categories) {
        uiState.value = currentUiState.copyWith(categories: categories);
      },
    );
  }

  Future<void> selectCategory(String? categoryName) async {
    log("Selecting category: $categoryName");

    if (categoryName == currentUiState.selectedCategory) {
      log("Deselecting category: $categoryName");
      uiState.value = currentUiState.copyWith(
        selectedCategory: null,
        isLoading: true,
      );
      await loadProducts();
      uiState.value = currentUiState.copyWith(isLoading: false);
      return;
    }

    uiState.value = currentUiState.copyWith(
      selectedCategory: categoryName,
      isLoading: true,
    );

    if (categoryName == null) {
      await loadProducts();
    } else {
      await parseDataFromEitherWithUserMessage(
        task: () => _getProductsByCategoryUseCase.execute(categoryName),
        onDataLoaded: (productList) {
          log(
            "Products by category loaded: ${productList.products.length} items",
          );
          uiState.value = currentUiState.copyWith(
            products: productList.products,
          );
        },

        valueOnError: const ProductListEntity(
          products: [],
          total: 0,
          skip: 0,
          limit: 0,
        ),
      );
    }

    uiState.value = currentUiState.copyWith(isLoading: false);
  }

  Future<void> refreshData() async {
    return executeTaskWithLoading(() async {
      await Future.wait([loadProducts(), loadCategories()]);
    });
  }

  void setSearchQuery(String query) {
    uiState.value = currentUiState.copyWith(
      searchQuery: query,
      isSearching: query.isNotEmpty,
    );

    Debounce.debounce('search_products', 0.5.inSeconds, () async {
      if (query.isEmpty) {
        if (currentUiState.selectedCategory != null) {
          await selectCategory(currentUiState.selectedCategory);
        } else {
          await loadProducts();
        }
        return;
      }

      await executeTaskWithLoading(() async {
        await parseDataFromEitherWithUserMessage(
          task: () => _searchProductsUseCase.execute(query),
          onDataLoaded: (productList) {
            uiState.value = currentUiState.copyWith(
              products: productList.products,
              selectedCategory: null,
            );
          },

          valueOnError: const ProductListEntity(
            products: [],
            total: 0,
            skip: 0,
            limit: 0,
          ),
        );
      });
    });
  }

  void clearSearch() {
    uiState.value = currentUiState.copyWith(
      searchQuery: '',
      isSearching: false,
    );

    if (currentUiState.selectedCategory != null) {
      selectCategory(currentUiState.selectedCategory);
    } else {
      loadProducts();
    }
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
