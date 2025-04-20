import 'package:flutter/material.dart';
import 'package:initial_project/core/config/app_screen.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final bool small;
  final int maxStars;

  const RatingStars({
    super.key,
    required this.rating,
    this.small = false,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    final double size = small ? fourteenPx : eighteenPx;
    final int fullStars = rating.floor();
    final bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxStars, (index) {
            if (index < fullStars) {
              return Icon(Icons.star, size: size, color: Colors.amber);
            } else if (index == fullStars && hasHalfStar) {
              return Icon(Icons.star_half, size: size, color: Colors.amber);
            } else {
              return Icon(Icons.star_border, size: size, color: Colors.amber);
            }
          }),
        ),
        SizedBox(width: fourPx),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: small ? twelvePx : fourteenPx,
            fontWeight: FontWeight.bold,
            color: Colors.amber.shade700,
          ),
        ),
      ],
    );
  }
}
