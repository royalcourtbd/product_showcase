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
    // লগ করি যে কোন ক্যাটেগরি সিলেক্ট করা হচ্ছে
    log("Selecting category: $categoryName");

    if (categoryName == currentUiState.selectedCategory) {
      // যদি একই ক্যাটেগরি আবার ক্লিক করা হয়, তাহলে ডিসিলেক্ট করি
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
      // ক্যাটেগরি অনুযায়ী প্রোডাক্ট লোড করি
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
        // এরর হলে খালি লিস্ট দেখাই
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

  void setSearchQuery(String query) {
    uiState.value = currentUiState.copyWith(
      searchQuery: query,
      isSearching: query.isNotEmpty,
    );

    // থ্রটল সার্চ টু অ্যাভয়েড টু ম্যানি API কলস
    Debounce.debounce('search_products', 0.5.inSeconds, () async {
      if (query.isEmpty) {
        // যদি কোয়েরি খালি হয়, তাহলে ক্যাটেগরিতে বা সব প্রোডাক্টে ফিরে যাই
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
              selectedCategory:
                  null, // সার্চ করার সময় ক্যাটেগরি সিলেকশন ক্লিয়ার করি
            );
          },
          // এরর হলে খালি লিস্ট দেখাই
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
