// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/chonhanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/choose_add.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/goods.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/history_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/home_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/statistics_screen.dart';
import '../controllers/add/nhaphang_controller.dart';
import '../controllers/statistics/doanhthu_controller.dart';
import '../controllers/statistics/khachhang_controller.dart';

class DashboardScreen extends StatefulWidget {
  int currentPage;
  DashboardScreen({super.key, required this.currentPage});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controllerHangHoa = Get.put(ChonHangHoaController());
  final controllerDoanhThu = Get.put(DoanhThuController());
  final controllerLocation = Get.put(NhapHangController());
  final controllerKhachHang = Get.put(KhachHangController());
  @override
  void initState() {
    super.initState();
    controllerHangHoa.loadAllHangHoa();
    controllerKhachHang.loadAllKhachHang();
    controllerKhachHang.loadAllDonXuatHang();
    controllerKhachHang.loadAllDonNhapHang();
    controllerDoanhThu.loadDoanhThuNgay();
    controllerDoanhThu.loadDoanhThuTuan();
    controllerDoanhThu.loadDoanhThuThang();
    controllerLocation.loadAllLocationsName();
  }

  final screen = [
    const HomePage(),
    const StatisticsScreen(),
    const SizedBox(),
    const HistoryScreen(),
    const Goods(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screen[widget.currentPage],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              //mau nen select
              indicatorColor: pink100Color,
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    );
                  } else {
                    return const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    );
                  }
                },
              )),
          child: NavigationBar(
            height: 65,
            backgroundColor: backGroundColor,
            selectedIndex: widget.currentPage,
            onDestinationSelected: (int currentPage) {
              if (currentPage == 2) {
                ChooseAddScreen.buildShowModalBottomSheet(context).then((_) {
                  restartScreen();
                });
              } else {
                setState(() => widget.currentPage = currentPage);
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Image(
                    image: AssetImage(homeIcon), height: 26, color: mainColor),
                selectedIcon: Image(
                    image: AssetImage(homePinkIcon),
                    height: 28,
                    color: mainColor),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Image(
                    image: AssetImage(statisticsIcon),
                    height: 26,
                    color: mainColor),
                selectedIcon: Image(
                    image: AssetImage(statisticsPinkIcon),
                    height: 28,
                    color: mainColor),
                label: 'Thống kê',
              ),
              NavigationDestination(
                icon: Image(
                  image: AssetImage(addIcon),
                  height: 26,
                  color: mainColor,
                ),
                selectedIcon: Image(
                  image: AssetImage(addPinkIcon),
                  height: 28,
                  color: mainColor,
                ),
                label: 'Thêm',
              ),
              NavigationDestination(
                icon: Image(
                  image: AssetImage(historyIcon),
                  height: 26,
                  color: mainColor,
                ),
                selectedIcon: Image(
                  image: AssetImage(historyPinkIcon),
                  height: 28,
                  color: mainColor,
                ),
                label: 'Lịch sử',
              ),
              NavigationDestination(
                icon: Image(
                  image: AssetImage(goodsIcon),
                  height: 26,
                  color: mainColor,
                ),
                selectedIcon: Image(
                  image: AssetImage(goodsPinkIcon),
                  height: 28,
                  color: mainColor,
                ),
                label: 'Hàng hóa',
              ),
            ],
          ),
        ));
  }

  void restartScreen() {
    setState(() {
      // Điều hướng đến trang HomePage và xóa bỏ các trang khác trong stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  currentPage: 0,
                )),
        (route) => false,
      );
      // Thực hiện các tác vụ khởi tạo lại dữ liệu hoặc load dữ liệu mới tại đây.
      controllerHangHoa.loadAllHangHoa();
      controllerDoanhThu.loadDoanhThuNgay();
      controllerDoanhThu.loadDoanhThuTuan();
      controllerDoanhThu.loadDoanhThuThang();
    });
  }
}
