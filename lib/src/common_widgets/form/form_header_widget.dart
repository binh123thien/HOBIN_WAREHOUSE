import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../fontSize/font_size.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.iHeight,
    required this.iWidth,
  });

  final String image, title, subtitle;
  final double iHeight, iWidth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(image),
            width: size.width * iWidth,
            height: size.height * iHeight,
          ),
          Text(title, style: TextStyle(fontSize: Font.sizes(context)[2])),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: Font.sizes(context)[2]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
