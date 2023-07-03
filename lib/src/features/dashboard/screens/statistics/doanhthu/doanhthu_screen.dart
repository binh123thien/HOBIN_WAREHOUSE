import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/color.dart';
import '../../../controllers/statistics/doanhthu_controller.dart';
import '../../../controllers/statistics/khachhang_controller.dart';
import 'widget/doanhthu_tieude_widget.dart';
import 'widget/doanhthutheongay/doanhthutheongay_widget.dart';
import 'widget/doanhthutheotuan/doanhthutheotuan.dart';

class DoanhThuScreen extends StatefulWidget {
  const DoanhThuScreen({super.key});

  @override
  State<DoanhThuScreen> createState() => _DoanhThuScreenState();
}

class _DoanhThuScreenState extends State<DoanhThuScreen> {
  final controllerKhachHang = Get.put(KhachHangController());
  final controllerDoanhThu = DoanhThuController.instance;

  @override
  void initState() {
    super.initState();
    controllerDoanhThu.loadDoanhThu();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      if (controllerDoanhThu.doanhThu.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final doanhthu = controllerDoanhThu.doanhThu;
        final doanhthuTheoTuan = controllerDoanhThu.doanhThuTheoTuan;
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                            DoanhThuTheoNgayWidget(doanhthu: doanhthu),
                            DoanhThuTheoTuanWidget(
                                doanhthuTheoTuan: doanhthuTheoTuan),
                            DoanhThuTieuDe(
                              tongdoanhthu: doanhthu[0].values.first,
                              thanhcong: doanhthu[0]["thanhcong"],
                              title: 'Hôm nay',
                              dangcho: doanhthu[0]["dangcho"],
                              huy: doanhthu[0]["huy"],
                              ngay: '',
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
    });
  }
}
