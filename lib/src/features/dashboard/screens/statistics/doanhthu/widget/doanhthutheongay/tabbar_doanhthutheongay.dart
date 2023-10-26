import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../history/widget/card_history.dart';
import 'card_mathang.dart';

class TabbarChiTietDoanhThu extends StatefulWidget {
  const TabbarChiTietDoanhThu({
    super.key,
    required this.allDonHangTrongNgay,
  });
  final List allDonHangTrongNgay;

  @override
  State<TabbarChiTietDoanhThu> createState() => _TabbarChiTietDoanhThuState();
}

class _TabbarChiTietDoanhThuState extends State<TabbarChiTietDoanhThu> {
  final controllerKhachHang = Get.put(KhachHangController());
  final KhachHangController controller = Get.find();
  List<dynamic> allMatHangTrongNgay = [];
  bool loadedData = false;
  @override
  void initState() {
    super.initState();
    controllerKhachHang
        .loadAllTongSanPhamTrongNgay(widget.allDonHangTrongNgay)
        .then((_) {
      setState(() {
        allMatHangTrongNgay = controller.allTongSanPhamTrongNgay;
        loadedData = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: backGroundColor.withOpacity(0.5),
            child: const TabBar(
              tabs: [
                Tab(
                  text: "Đơn hàng",
                ),
                Tab(
                  text: "Mặt hàng",
                ),
              ],
              indicatorColor: mainColor,
              labelColor: darkColor,
              // indicatorSize: TabBarIndicatorSize.label,
              // isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          SizedBox(
            height: size.height * 0.595,
            width: size.width,
            child: TabBarView(
              children: [
                SizedBox(
                  child: widget.allDonHangTrongNgay.isNotEmpty
                      ? SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: ((BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: whiteColor,
                                  child: Column(
                                    children: [
                                      CardHistory(
                                        docs: widget.allDonHangTrongNgay,
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage(nodataIcon),
                                height: size.width * 0.7,
                                width: size.width * 0.7,
                              ),
                              Text(
                                "Bạn chưa có đơn hàng nào...",
                                style:
                                    TextStyle(fontSize: Font.sizes(context)[2]),
                              ),
                            ],
                          ),
                        ),
                ),
                loadedData == true
                    ? SizedBox(
                        child: widget.allDonHangTrongNgay.isNotEmpty
                            ? SizedBox(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      ((BuildContext context, int index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: whiteColor,
                                      child: Column(
                                        children: [
                                          CardMatHang(
                                            docs: allMatHangTrongNgay,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: const AssetImage(nodataIcon),
                                      height: size.width * 0.7,
                                      width: size.width * 0.7,
                                    ),
                                    Text(
                                      "Bạn chưa có mặt hàng nào...",
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[2]),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
