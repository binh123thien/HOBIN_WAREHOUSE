import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/khachhang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/kho.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/sono.dart';
import '../../../../../constants/icon.dart';

class ShortCutIcon extends StatelessWidget {
  const ShortCutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> shortcuts = [
      {
        "icon": khachhangIcon,
        "title": "Khách hàng",
        "link": const KhachHangShortCutScreen(),
      },
      {
        "icon": khoIcon,
        "title": "Kho",
        "link": const KhoShortCutScreen(),
      },
      {
        "icon": sonoIcon,
        "title": "Sổ nợ",
        "link": const SoNoShortCutScreen(),
      }
    ];
    return SizedBox(
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
                  MaterialPageRoute(builder: (context) => doc["link"]),
                ),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(doc["icon"]!), height: 30),
                      const SizedBox(height: 5),
                      Text(doc["title"]!, style: const TextStyle(fontSize: 14)),
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
