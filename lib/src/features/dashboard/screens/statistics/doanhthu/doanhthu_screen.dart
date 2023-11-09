import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/doanhthu/widget/doanhthutheothang/doanhthutheothang_widget.dart';
import '../../../../../constants/color.dart';
import '../../../controllers/statistics/doanhthu_controller.dart';
import 'widget/doanhthutheongay/doanhthutheongay_widget.dart';
import 'widget/doanhthutheotuan/doanhthutheotuan.dart';

class DoanhThuScreen extends StatefulWidget {
  const DoanhThuScreen({super.key});

  @override
  State<DoanhThuScreen> createState() => _DoanhThuScreenState();
}

class _DoanhThuScreenState extends State<DoanhThuScreen> {
  final controllerDoanhThu = Get.put(DoanhThuController());

  @override
  void initState() {
    super.initState();
    controllerDoanhThu.loadDoanhThuNgay();
    controllerDoanhThu.loadDoanhThuTuan();
    controllerDoanhThu.loadDoanhThuThang();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doanhthungay = controllerDoanhThu.docDoanhThuNgay;
    final doanhthutuan = controllerDoanhThu.docDoanhThuTuan;
    final doanhthuthang = controllerDoanhThu.docDoanhThuThang;
    return Container(
      width: size.width,
      color: whiteColor,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: whiteColor,
              title: const TabBar(
                tabs: [
                  Tab(
                    text: "Hàng ngày",
                  ),
                  Tab(
                    text: "Hàng tuần",
                  ),
                  Tab(
                    text: "Hàng tháng",
                  ),
                ],
                indicatorColor: Colors.black,
                labelColor: darkColor,
                // labelPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            SizedBox(
              height: size.height * 0.75,
              width: size.width - 16,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TabBarView(
                  children: [
                    DoanhThuTheoNgayWidget(doanhthu: doanhthungay),
                    DoanhThuTheoTuanWidget(doanhthuTheoTuan: doanhthutuan),
                    DoanhThuTheoThangWidget(
                      doanhthutheothang: doanhthuthang,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
