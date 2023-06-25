import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/widget/cardphanphoihang_widget.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';

class ChonHangHoaLeScreen extends StatefulWidget {
  final dynamic hanghoaLe;
  final dynamic hanghoaSi;
  const ChonHangHoaLeScreen({super.key, this.hanghoaLe, this.hanghoaSi});

  @override
  State<ChonHangHoaLeScreen> createState() => _ChonHangHoaLeScreenState();
}

class _ChonHangHoaLeScreenState extends State<ChonHangHoaLeScreen> {
  late dynamic updatehanghoaSi;
  late dynamic updatehanghoaLe;
  @override
  void initState() {
    updatehanghoaSi = widget.hanghoaSi;
    updatehanghoaLe = widget.hanghoaLe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
      ),
      backgroundColor: backGroundDefaultFigma,
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CardPhanPhoiHang(
                  imageProduct: distributeGoodIcon,
                  donViProduct: updatehanghoaSi['donvi'],
                  updatehanghoa: updatehanghoaSi),
              const Icon(
                Icons.east_outlined,
              ),
              CardPhanPhoiHang(
                  imageProduct: distributeGoodIcon,
                  donViProduct: updatehanghoaLe['donvi'],
                  updatehanghoa: updatehanghoaLe),
              // Container(
              //   child: Row(
              //     children: [
              //       Image(
              //         image: AssetImage(distributeGoodIcon),
              //         height: 30,
              //       ),
              //       Text(updatehanghoaLe['donvi']),
              //       Text(updatehanghoaLe['tensanpham'])
              //     ],
              //   ),
              // )
            ]),
          ]),
        ),
      ),
    );
  }
}
