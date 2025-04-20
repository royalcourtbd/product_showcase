import 'package:flutter/material.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/utility.dart';
import 'package:initial_project/domain/entities/product_entity.dart';
import 'package:initial_project/presentation/product/widgets/rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius10,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityInt(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
                errorWidget:
                    (context, error, stackTrace) => Container(
                      color: context.color.blackColor100,
                      child: Icon(Icons.image_not_supported, size: thirtyPx),
                    ),
              ),
              // child: Image.network(
              //   product.thumbnail,
              //   fit: BoxFit.cover,
              //   errorBuilder:
              //       (_, __, ___) => Container(
              //         color: context.color.blackColor100,
              //         child: Icon(
              //           Icons.image_not_supported,
              //           color: context.color.blackColor300,
              //           size: thirtyPx,
              //         ),
              //       ),
              // ),
            ),

            Padding(
              padding: padding8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.color.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Title
                  Text(
                    product.title,

                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gapH4,

                  // Rating
                  RatingStars(rating: product.rating, small: true),
                  gapH4,

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        gapW5,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: fourPx,
                            vertical: twoPx,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.successColor,
                            borderRadius: radius4,
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: tenPx,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Stock
                  Text(
                    product.stock > 0
                        ? 'In Stock (${product.stock})'
                        : 'Out of Stock',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          product.stock > 0
                              ? context.color.successColor
                              : context.color.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
