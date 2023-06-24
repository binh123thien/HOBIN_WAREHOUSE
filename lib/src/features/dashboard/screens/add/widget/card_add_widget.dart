import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class CardAdd extends StatelessWidget {
  const CardAdd({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final String icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: backGroundColor,
                ),
                child: Transform.scale(
                  scale: 0.6, // Tùy chỉnh giá trị này để điều chỉnh kích thước
                  child: ImageIcon(AssetImage(icon)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
