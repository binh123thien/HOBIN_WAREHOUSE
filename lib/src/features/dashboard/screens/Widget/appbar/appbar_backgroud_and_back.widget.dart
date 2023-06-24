import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';

import '../../../../../common_widgets/dialog/dialog.dart';

class AppBarBGBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBGBack({
    super.key,
    required this.title,
  });
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(tBackGround1), // where is this variable defined?
            fit: BoxFit.cover,
          ),
        ),
      ),
      leading: IconButton(
          icon: const Image(
            image: AssetImage(backIcon),
            height: 20,
            color: whiteColor,
          ),
          onPressed: () {
            MyDialog.showAlertDialog(
              context,
              "Xác nhận",
              "Bạn muốn thoát trang nhập hàng?",
              () {
                Navigator.of(context)
                    .pop(); // Đóng dialog và trả về giá trị false
                //Đóng bottomsheet
                Navigator.of(context).pop();
              },
            );
          }),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
    );
  }
}
