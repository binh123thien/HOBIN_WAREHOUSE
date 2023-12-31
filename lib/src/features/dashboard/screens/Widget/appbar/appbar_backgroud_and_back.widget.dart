import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

class AppBarBGBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBGBack({
    super.key,
    required this.title,
    required this.phanBietNhatXuat,
  });
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String title;
  final int phanBietNhatXuat;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: phanBietNhatXuat == 0 ? mainColor : blueColor,
      leading: IconButton(
          icon: const Image(
            image: AssetImage(backIcon),
            height: 20,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
    );
  }
}
