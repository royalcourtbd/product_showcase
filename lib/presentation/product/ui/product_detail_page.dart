import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/external_libs/presentable_widget_builder.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/ui_helper.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/presentation/product/presenter/product_details_presenter.dart';
import 'package:initial_project/presentation/product/widgets/image_carousel.dart';
import 'package:initial_project/presentation/product/widgets/rating_stars.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailPresenter _presenter =
      locate<ProductDetailPresenter>();

  @override
  void initState() {
    super.initState();
    UiHelper.onMessage(_presenter.uiState, context);
    _presenter.loadProductDetails(widget.productId);
  }

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
        builder: () {
          final state = _presenter.currentUiState;

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                // Image Carousel
                ImageCarousel(images: [product.thumbnail, ...product.images]),

                Padding(
                  padding: padding15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Category
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

                      // Price and Rating
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

                      // Description
                      Text('Description', style: theme.textTheme.titleLarge),
                      gapH8,
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      gapH16,

                      // Product Details
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

                      // Call to Action
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
