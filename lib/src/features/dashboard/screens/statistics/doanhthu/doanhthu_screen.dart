import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/color.dart';
import '../../../controllers/statistics/doanhthu_controller.dart';
import 'widget/doanhthu_tieude_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doanhthungay = controllerDoanhThu.docDoanhThuNgay;
    final doanhthutuan = controllerDoanhThu.docDoanhThuTuan;
    print(doanhthungay);
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: size.width,
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: AppBar(
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
                      indicatorColor: mainColor,
                      labelColor: darkColor,
                      // labelPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                Container(
                  height: size.height - kToolbarHeight - 171,
                  width: size.width - 16,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TabBarView(
                      children: [
                        DoanhThuTheoNgayWidget(doanhthu: doanhthungay),
                        DoanhThuTheoTuanWidget(doanhthuTheoTuan: doanhthutuan),
                        DoanhThuTieuDe(
                          phanloai: "thang",
                          tongdoanhthu: 0,
                          thanhcong: 0,
                          title: 'Hôm nay',
                          dangcho: 0,
                          huy: 0,
                          ngay: '',
                          week: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
