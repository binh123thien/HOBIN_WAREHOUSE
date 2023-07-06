import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_widget.dart';

import '../../../../controllers/add/chonhanghoa_controller.dart';

class CardKhoWidget extends StatefulWidget {
  const CardKhoWidget({super.key});

  @override
  State<CardKhoWidget> createState() => _CardKhoWidgetState();
}

class _CardKhoWidgetState extends State<CardKhoWidget> {
  final controller = Get.put(ChonHangHoaController());
  @override
  void initState() {
    super.initState();
    controller.loadAllHangHoa();
  }

  @override
  Widget build(BuildContext context) {
    num sltonkho = 0;
    for (var item in controller.allHangHoaFireBase) {
      sltonkho += item["tonkho"];
    }
    final num giatritonkho = controller.allHangHoaFireBase
        .fold(0, (sum, item) => sum + item['gianhap'] * item['tonkho']);
    List cardkho = [
      {
        "icon": const AssetImage(soluongtonkhoIcon),
        "title": "Sl tồn kho",
        "value": sltonkho.toString(),
      },
      {
        "icon": const AssetImage(giatritonkhoIcon),
        "title": "Giá trị tồn kho",
        "value": giatritonkho,
      },
    ];
    return CardWidget(arrayList: cardkho);
  }
}
