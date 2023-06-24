import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';

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
    return Column(
      children: [
        Image(
          image: AssetImage(image),
          width: size.width * iWidth,
          height: size.height * iHeight,
        ),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: tDefaultSize - 15),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
