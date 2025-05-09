import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/external_libs/presentable_widget_builder.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/ui_helper.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/presentation/common/loading_indicator.dart';
import 'package:initial_project/presentation/product/presenter/product_list_presenter.dart';
import 'package:initial_project/presentation/product/presenter/product_list_ui_state.dart.dart';
import 'package:initial_project/presentation/product/ui/product_detail_page.dart';
import 'package:initial_project/presentation/product/widgets/category_filter_chips.dart';
import 'package:initial_project/presentation/product/widgets/product_card.dart';
import 'package:initial_project/presentation/product/widgets/product_search_bar.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  late final ProductListPresenter _presenter = locate<ProductListPresenter>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: PresentableWidgetBuilder(
        presenter: _presenter,
        onInit: () {
          UiHelper.onMessage(_presenter.uiState, context);
        },
        builder: () {
          final ProductListUiState state = _presenter.currentUiState;

          return Column(
            children: [
              ProductSearchBar(
                value: state.searchQuery,
                onChanged: _presenter.setSearchQuery,
                onClear: _presenter.clearSearch,
                isSearching: state.isSearching,
              ),

              if (state.categories.isNotEmpty && !state.isSearching)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: tenPx),
                  child: CategoryFilterChips(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: _presenter.selectCategory,
                  ),
                ),

              Expanded(
                child:
                    state.isLoading
                        ? Center(
                          child: LoadingIndicator(theme: Theme.of(context)),
                        )
                        : RefreshIndicator(
                          onRefresh: _presenter.refreshData,
                          color: context.color.primaryColor,
                          child:
                              state.products.isEmpty
                                  ? ListView(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                            3,
                                        child: Center(
                                          child: Text(
                                            'No products found',
                                            style: theme.textTheme.titleMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : GridView.builder(
                                    padding: padding15,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.7,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                    itemCount: state.products.length,
                                    itemBuilder: (context, index) {
                                      final product = state.products[index];
                                      return ProductCard(
                                        product: product,
                                        onTap:
                                            () => _navigateToProductDetail(
                                              product,
                                            ),
                                      );
                                    },
                                  ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToProductDetail(ProductEntity product) {
    Get.to(() => ProductDetailPage(productId: product.id));
  }
}
