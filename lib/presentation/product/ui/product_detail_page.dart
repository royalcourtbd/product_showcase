import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/external_libs/presentable_widget_builder.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/ui_helper.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/presentation/common/loading_indicator.dart';
import 'package:initial_project/presentation/product/presenter/product_details_presenter.dart';
import 'package:initial_project/presentation/product/widgets/image_carousel.dart';
import 'package:initial_project/presentation/product/widgets/rating_stars.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({super.key, required this.productId});

  late final ProductDetailPresenter _presenter =
      locate<ProductDetailPresenter>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: PresentableWidgetBuilder(
        presenter: _presenter,
        onInit: () {
          UiHelper.onMessage(_presenter.uiState, context);
          _presenter.loadProductDetails(productId);
        },
        builder: () {
          final state = _presenter.currentUiState;

          if (state.isLoading) {
            return Center(child: LoadingIndicator(theme: theme));
          }

          if (state.product == null) {
            return Center(
              child: Text(
                'Product not found',
                style: theme.textTheme.titleMedium,
              ),
            );
          }

          final product = state.product!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarousel(images: [product.thumbnail, ...product.images]),

                Padding(
                  padding: padding15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.category,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.color.primaryColor,
                        ),
                      ),
                      gapH12,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (product.discountPercentage > 0) ...[
                                gapW8,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: eightPx,
                                    vertical: fourPx,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.color.successColor,
                                    borderRadius: radius4,
                                  ),
                                  child: Text(
                                    '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          RatingStars(rating: product.rating),
                        ],
                      ),
                      gapH16,

                      Text('Description', style: theme.textTheme.titleLarge),
                      gapH8,
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      gapH16,

                      Text(
                        'Product Details',
                        style: theme.textTheme.titleLarge,
                      ),
                      gapH8,
                      _buildDetailRow('Brand', product.brand ?? 'N/A', theme),
                      _buildDetailRow('SKU', product.sku, theme),
                      _buildDetailRow(
                        'Availability',
                        product.availabilityStatus,
                        theme,
                      ),
                      _buildDetailRow('Stock', '${product.stock} units', theme),
                      _buildDetailRow(
                        'Shipping',
                        product.shippingInformation,
                        theme,
                      ),
                      _buildDetailRow(
                        'Return Policy',
                        product.returnPolicy,
                        theme,
                      ),
                      _buildDetailRow(
                        'Warranty',
                        product.warrantyInformation,
                        theme,
                      ),
                      gapH22,

                      ElevatedButton(
                        onPressed: () {
                          showMessage(message: 'Added to cart!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.color.primaryColor,
                          minimumSize: Size(double.infinity, fiftyPx),
                          shape: RoundedRectangleBorder(borderRadius: radius10),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: sixteenPx,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return DetailRowWidget(label: label, value: value, theme: theme);
  }
}

class DetailRowWidget extends StatelessWidget {
  const DetailRowWidget({
    super.key,
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fourPx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.color.titleColor,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
