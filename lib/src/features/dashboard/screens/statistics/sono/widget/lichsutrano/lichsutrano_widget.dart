import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../Widget/appbar/search_widget.dart';
import 'card_lichsutrano.dart';

class LichSuTraNoWidget extends StatefulWidget {
  const LichSuTraNoWidget({super.key});

  @override
  State<LichSuTraNoWidget> createState() => _LichSuTraNoWidgetState();
}

class _LichSuTraNoWidgetState extends State<LichSuTraNoWidget> {
  String searchKhachHang = "";
  final controller = Get.put(KhachHangController());
  late List<dynamic> allLichSuTraNo;
  @override
  void initState() {
    allLichSuTraNo = controller.allLichSuTraNoFirebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredList = allLichSuTraNo
        .where((item) => item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(searchKhachHang.toLowerCase()))
        .toList();
    filteredList.sort((b, a) => a['soHD'].compareTo(b['soHD']));
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SearchWidget(
            onChanged: (value) {
              setState(() {
                searchKhachHang = value;
              });
            },
            width: size.width * 0.9,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          color: whiteColor,
          width: size.width,
          height: size.height * 0.6,
          child: CardLichSuTraNo(allLichSuTraNo: filteredList),
        ),
      ],
    );
  }
}
