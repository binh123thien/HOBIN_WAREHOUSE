import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/banhang/banhang_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/thanhcong/thanhcong_screen.dart';

import 'dangcho/dangcho_screen.dart';
import 'huy/huy_screen.dart';
import 'nhaphang/nhaphang_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            title: const Text("Lịch sử giao dịch",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: darkColor)),
            backgroundColor: backGroundColor,
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Bán Hàng",
                ),
                Tab(
                  text: "Nhập Hàng",
                ),
                Tab(
                  text: "Thành Công",
                ),
                Tab(
                  text: "Đang Chờ",
                ),
                Tab(
                  text: "Hủy",
                )
              ],
              indicatorColor: mainColor,
              labelColor: darkColor,
              isScrollable: true,
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                shrinkWrap: true,
                children: const [
                  BanHangScreen(),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  NhapHangHistoryScreen(),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  ThanhCongHistoryScreen(),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  DangChoHistoryScreen(),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  HuyHistoryScreen(),
                ],
              ),
            ],
          ),
        ));
  }
}
