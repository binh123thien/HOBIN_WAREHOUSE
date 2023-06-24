import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_widget.dart';

class CardDashboard extends StatefulWidget {
  const CardDashboard({super.key});

  @override
  State<CardDashboard> createState() => _CardDashboardState();
}

class _CardDashboardState extends State<CardDashboard> {
  List exspense = [
    {
      "icon": const AssetImage(slTonKho),
      "title": "SL tồn kho",
      "value": "1.200",
    },
    {
      "icon": const AssetImage(gtriTonkho),
      "title": "GT tồn kho",
      "value": "\$200.333.222",
    },
    {
      "icon": const AssetImage(phiNhapHang),
      "title": "Nhập hàng",
      "value": "\$1.920.000",
    },
    {
      "icon": const AssetImage(doanthu),
      "title": "Doanh thu",
      "value": "\$231.000",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return CardWidget(arrayList: exspense);
  }
}
