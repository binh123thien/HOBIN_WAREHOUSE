import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';
import 'danhsachno/danhsachno_widget.dart';
import 'donno/donno_widget.dart';
import 'lichsutrano/lichsutrano_widget.dart';

class TabbarSoNoWidget extends StatefulWidget {
  const TabbarSoNoWidget({super.key});

  @override
  State<TabbarSoNoWidget> createState() => _TabbarSoNoWidgetState();
}

class _TabbarSoNoWidgetState extends State<TabbarSoNoWidget>
    with TickerProviderStateMixin {
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
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 4,
            automaticallyImplyLeading: false,
            backgroundColor: whiteColor,
            title: const TabBar(
              tabs: [
                Tab(
                  text: "Khách nợ",
                ),
                Tab(
                  text: "Đơn nợ",
                ),
                Tab(
                  text: "Lịch sử trả nợ",
                ),
              ],
              indicatorColor: mainColor,
              labelColor: darkColor,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
            ),
          ),
          Container(
            color: whiteColor,
            height: MediaQuery.of(context).size.height - kToolbarHeight - 145,
            child: const TabBarView(
              children: [
                DanhSachNoWidget(),
                DonNoWidget(),
                LichSuTraNoWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
