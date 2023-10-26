import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_widget.dart';
import '../../../../controllers/add/chonhanghoa_controller.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';

class CardSoNoWidget extends StatefulWidget {
  const CardSoNoWidget({super.key});

  @override
  State<CardSoNoWidget> createState() => _CardSoNoWidgetState();
}

class _CardSoNoWidgetState extends State<CardSoNoWidget> {
  final controller = Get.put(KhachHangController());
  final controllerHangHoa = Get.put(ChonHangHoaController());

  @override
  Widget build(BuildContext context) {
    List<dynamic> allDon = [];
    allDon.addAll(controller.allDonBanHangFirebase);
    allDon.addAll(controller.allDonNhapHangFirebase);
    int sodonno = allDon
        .where((doc) => doc["no"] != 0 && doc["trangthai"] != "Hủy")
        .length;
    double tongtienno = allDon.fold(0.0, (sum, doc) {
      if (doc["no"] != null && doc["trangthai"] != "Hủy") {
        return sum + doc["no"];
      } else {
        return sum;
      }
    });
    List cardsono = [
      {
        "icon": const AssetImage(tongdonnoIcon),
        "title": tTongDonNo,
        "value": sodonno.toString(),
      },
      {
        "icon": const AssetImage(tongtiennoIcon),
        "title": tTongTienNo,
        "value": tongtienno,
      },
    ];
    return CardWidget(
      arrayList: cardsono,
      height: MediaQuery.of(context).size.height * 0.12,
    );
  }
}
