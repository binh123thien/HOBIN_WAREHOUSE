import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class SearchWidget extends StatelessWidget {
  final double width;
  const SearchWidget({
    super.key,
    required this.onChanged,
    required this.width,
  });
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 43,
      child: TextField(
        onChanged: onChanged,
        // focusNode: FocusNode(), // unnecessary
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: whiteColor, // where is this color defined?
          contentPadding: EdgeInsets.zero,
          prefixIconColor: darkColor,
          floatingLabelStyle: const TextStyle(color: darkColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(width: 2, color: pink600Color),
          ),
          prefixIcon: const Icon(Icons.search),
          hintText: "Tìm Kiếm",
        ),
      ),
    );
  }
}
