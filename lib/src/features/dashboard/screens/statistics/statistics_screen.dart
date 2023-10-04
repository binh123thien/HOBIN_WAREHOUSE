import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/doanhthu/doanhthu_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/khachhang/khachhang_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/kho/kho_screen.dart';
import '../../controllers/statistics/khachhang_controller.dart';
import 'sono/sono_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final controller = Get.put(KhachHangController());
  @override
  void initState() {
    super.initState();
    controller.loadAllKhachHang();
    controller.loadAllDonXuatHang();
    controller.loadAllDonNhapHang();
    controller.loadAllLichSuTraNo();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mainColor,
          title: const TabBar(
            tabs: [
              Tab(
                text: "Doanh thu",
              ),
              Tab(
                text: "Khách hàng",
              ),
              Tab(
                text: "Kho",
              ),
              Tab(
                text: "Sổ nợ",
              )
            ],
            indicatorColor: whiteColor,
            labelColor: whiteColor,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        body: const TabBarView(
          children: [
            DoanhThuScreen(),
            KhachHangScreen(),
            KhoScreen(),
            SoNoScreen(),
          ],
        ),
      ),
    );
  }
}
