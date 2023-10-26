import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/banhang/banhang_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/thanhcong/thanhcong_screen.dart';

import '../../../../common_widgets/fontSize/font_size.dart';
import '../Widget/appbar/search_widget.dart';
import 'dangcho/dangcho_screen.dart';
import 'hethan/hethan_history_screen.dart';
import 'huy/huy_screen.dart';
import 'nhaphang/nhaphang_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String searchHistory = "";

  late PageController _pageController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: Text("Lịch sử giao dịch",
              style: TextStyle(
                  fontSize: Font.sizes(context)[2],
                  fontWeight: FontWeight.w700,
                  color: whiteColor)),
          backgroundColor: mainColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.1),
            child: Container(
              color: whiteColor,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SearchWidget(
                        onChanged: (value) {
                          setState(() {
                            searchHistory = value;
                          });
                        },
                        width: size.width * 0.9,
                      ),
                    ],
                  ),
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                    tabs: const [
                      Tab(
                        text: "Xuất Hàng",
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
                      ),
                      Tab(
                        text: "Hết Hạn",
                      )
                    ],
                    indicatorColor: Colors.black,
                    labelColor: darkColor,
                    isScrollable: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Ngăn kéo trái/phải trong PageView
          itemCount: 6,
          itemBuilder: (context, index) {
            return ListView(
              shrinkWrap: true,
              children: [
                if (index == 0)
                  XuatHangScreen(searchHistory: searchHistory)
                else if (index == 1)
                  NhapHangHistoryScreen(searchHistory: searchHistory)
                else if (index == 2)
                  ThanhCongHistoryScreen(searchHistory: searchHistory)
                else if (index == 3)
                  DangChoHistoryScreen(searchHistory: searchHistory)
                else if (index == 4)
                  HuyHistoryScreen(searchHistory: searchHistory)
                else if (index == 5)
                  HetHanHistoryScreen(searchHistory: searchHistory),
              ],
            );
          },
        ),
      ),
    );
  }
}
