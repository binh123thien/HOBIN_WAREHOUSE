import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_widget.dart';

import '../../../controllers/history/history_controller.dart';

class CardDashboard extends StatelessWidget {
  const CardDashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controllerHistoryRepo = Get.find();

    return Obx(() {
      List<Map<String, dynamic>> expenses = [
        {
          "icon": const AssetImage(slTonKho),
          "title": "SL tồn kho",
          "value": controllerHistoryRepo.soluongtonkho.value,
        },
        {
          "icon": const AssetImage(gtriTonkho),
          "title": "GT tồn kho",
          "value": controllerHistoryRepo.giatritonkho.value,
        },
        {
          "icon": const AssetImage(phiNhapHang),
          "title": "Nhập hàng",
          "value": controllerHistoryRepo.tongNhapHang.value,
        },
        {
          "icon": const AssetImage(doanthu),
          "title": "Doanh thu",
          "value": controllerHistoryRepo.tongBanHang.value,
        },
      ];

      return CardWidget(
        arrayList: expenses,
      );
    });
  }
}
