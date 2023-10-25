import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/hethan/hethan.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/khachhang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/kho.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/sono.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../constants/icon.dart';

class ShortCutIcon extends StatelessWidget {
  const ShortCutIcon({super.key});

  @override
  Widget build(BuildContext context) {
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
      },
      {
        "icon": hethanIcon,
        "title": "Hết hạn",
        "link": const HetHanShortcutScreen(),
      },
    ];
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.12,
      decoration: BoxDecoration(
          border: Border.all(color: darkLiteColor),
          borderRadius: BorderRadius.circular(10),
          color: whiteColor),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 4,
            children: shortcuts.map((shortcut) {
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: shortcut["link"])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(shortcut["icon"]), height: 30),
                    const SizedBox(height: 10),
                    Text(
                      shortcut['title'],
                      style: TextStyle(fontSize: Font.sizes(context)[0]),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
    );
  }
}
