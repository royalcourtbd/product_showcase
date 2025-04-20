import 'package:flutter/material.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/static/ui_const.dart';
import 'package:initial_project/core/utility/utility.dart';

class ProductSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const ProductSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(tenPx),
      color: context.color.backgroundColor,
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: context.color.blackColor400),
          suffixIcon:
              value.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: context.color.blackColor400),
                    onPressed: onClear,
                  )
                  : null,
          fillColor: context.color.blackColor50,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: twelvePx),
          border: OutlineInputBorder(
            borderRadius: radius20,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius20,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius20,
            borderSide: BorderSide(
              color: context.color.primaryColor.withOpacityInt(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
