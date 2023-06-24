// ignore_for_file: implementation_imports, unused_import

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_danhsach_2cot_widget.dart';

import '../../../../controllers/add/chonhanghoa_controller.dart';

class PhanLoaiKhoWidget extends StatefulWidget {
  const PhanLoaiKhoWidget({super.key});

  @override
  State<PhanLoaiKhoWidget> createState() => _PhanLoaiKhoWidgetState();
}

class _PhanLoaiKhoWidgetState extends State<PhanLoaiKhoWidget> {
  final controllerHangHoa = Get.put(ChonHangHoaController());
  late List<dynamic> alldanhmuc;
  @override
  void initState() {
    super.initState();
    alldanhmuc = controllerHangHoa.categoryCountList;
  }

  @override
  Widget build(BuildContext context) {
    // print(alldanhmuc);
    // print(controllerHangHoa.categoryCountList);
    return CardDanhSach2cotWidget(
      nameArr: alldanhmuc,
      height: 345,
    );
  }
}
