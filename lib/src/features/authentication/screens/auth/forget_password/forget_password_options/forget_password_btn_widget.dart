import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';

class ForgetPasswordBtnWidget extends StatelessWidget {
  const ForgetPasswordBtnWidget({
    // gọi biến trên
    required this.btnIcon,
    required this.title,
    required this.subTittle,
    required this.onTap,
    super.key,
  });

//đặt tên hàm
  final String title, subTittle;
  final IconData btnIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(tDefaultSize - 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade300),
        child: Row(
          children: [
            Icon(
              btnIcon,
              size: 60,
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: Font.sizes(context)[1]),
                ),
                Text(
                  subTittle,
                  style: TextStyle(fontSize: Font.sizes(context)[1]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
