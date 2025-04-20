import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/utility.dart';

class CategoryFilterChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: eightPx, top: tenPx, bottom: sixPx),
          child: Text(
            'Categories',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: fortyPx,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: fourPx),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: fourPx),
                child: FilterChip(
                  label: Text(
                    _formatCategoryName(category),
                    style: TextStyle(
                      color:
                          isSelected
                              ? context.color.whiteColor
                              : context.color.titleColor,
                      fontSize: thirteenPx,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => onCategorySelected(category),
                  backgroundColor: context.color.blackColor50,
                  selectedColor: context.color.primaryColor,
                  checkmarkColor: context.color.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: radius15,
                    side: BorderSide(
                      color:
                          isSelected
                              ? Colors.transparent
                              : context.color.blackColor200,
                      width: 1,
                    ),
                  ),
                  padding: padding8,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatCategoryName(String category) {
    if (category.isEmpty) return '';
    if (category.contains('-')) {
      return category
          .split('-')
          .map(
            (word) =>
                word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
          )
          .join(' ');
    }

    String result = category[0].toUpperCase() + category.substring(1);
    log(result);
    return result;
  }
}
