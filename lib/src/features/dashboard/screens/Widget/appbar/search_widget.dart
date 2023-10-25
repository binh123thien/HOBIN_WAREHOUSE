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
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: width,
      height: size.height * 0.045,
      child: TextField(
        onChanged: onChanged,
        // focusNode: FocusNode(), // unnecessary
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: backGroundSearch, // where is this color defined?
          contentPadding: EdgeInsets.zero,
          prefixIconColor: darkLiteColor,
          floatingLabelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search),
          hintText: "Tìm Kiếm",
        ),
      ),
    );
  }
}
