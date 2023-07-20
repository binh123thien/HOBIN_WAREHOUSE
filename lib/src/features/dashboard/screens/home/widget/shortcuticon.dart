import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/khachhang.dart';

import '../../../../../constants/icon.dart';
import '../../statistics/khachhang/khachhang_screen.dart';
import '../../statistics/kho/kho_screen.dart';
import '../../statistics/sono/sono_screen.dart';

class ShortCutIcon extends StatelessWidget {
  const ShortCutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> shortcuts = [
      {
        "icon": khachhangIcon,
        "title": "Khách hàng",
        "link": const KhachHangScreen(),
      },
      {
        "icon": khoIcon,
        "title": "Kho",
        "link": const KhoScreen(),
      },
      {
        "icon": sonoIcon,
        "title": "Sổ nợ",
        "link": const SoNoScreen(),
      }
    ];
    return Container(
      width: size.width,
      height: 60,
      child: Wrap(
        spacing: 35,
        alignment: WrapAlignment.center,
        children: List.generate(3, (index) {
          final doc = shortcuts[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KhachHangShortCutScreen()),
                ),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(doc["icon"]!), height: 30),
                      SizedBox(height: 5),
                      Text(doc["title"]!, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
