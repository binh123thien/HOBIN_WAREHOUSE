import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class Button2nutBar extends StatelessWidget {
  const Button2nutBar({
    super.key,
    required this.title1,
    required this.title2,
    required this.onPressed1,
    required this.onPressed2,
  });
  final String title1;
  final String title2;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      height: size.height * 0.086,
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.435, // 170
            height: size.height * 0.0623, // 50
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: mainColor),
                  foregroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // giá trị này xác định bán kính bo tròn
                  ),
                ),
                onPressed: onPressed1,
                child: Text(title1,
                    style: TextStyle(
                        fontSize: Font.sizes(context)[1],
                        fontWeight: FontWeight.w600))),
          ),
          SizedBox(
              width: size.width * 0.435, // 170
              height: size.height * 0.0623, // 50
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    side: const BorderSide(color: mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: onPressed2,
                  child: Text(
                    title2,
                    style: TextStyle(fontSize: Font.sizes(context)[1]),
                  )))
        ],
      ),
    );
  }
}
