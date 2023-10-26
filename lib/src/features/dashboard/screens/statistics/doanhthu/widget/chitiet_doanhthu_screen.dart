import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/doanhthu/widget/stream_chitietdoanhthutuanthang.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../controllers/statistics/doanhthu_controller.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';
import 'card/card_chitietdoanhthu.dart';
import 'doanhthutheongay/tabbar_doanhthutheongay.dart';

class ChiTietDoanhThuScreen extends StatefulWidget {
  final String ngay;
  final String week;
  final String loai;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;
  const ChiTietDoanhThuScreen(
      {super.key,
      required this.ngay,
      required this.tongdoanhthu,
      required this.thanhcong,
      required this.dangcho,
      required this.huy,
      required this.loai,
      required this.week});

  @override
  State<ChiTietDoanhThuScreen> createState() => _ChiTietDoanhThuScreenState();
}

class _ChiTietDoanhThuScreenState extends State<ChiTietDoanhThuScreen> {
  final KhachHangController controller = Get.find();
  final controllerDoanhThu = DoanhThuController.instance;
  List<dynamic> allDonHang = [];
  List<dynamic> allDonHangTrongNgay = [];

  @override
  void initState() {
    super.initState();
    allDonHang = controller.allDonBanHangFirebase;
    allDonHangTrongNgay =
        allDonHang.where((doc) => doc["datetime"] == widget.ngay).toList();
    allDonHangTrongNgay.sort((a, b) => b["soHD"].compareTo(a["soHD"]));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                size: size.width * 0.06, color: whiteColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.ngay,
            style: TextStyle(
                fontSize: Font.sizes(context)[2],
                fontWeight: FontWeight.w900,
                color: whiteColor)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.13,
                color: mainColor,
              ),
              Column(
                children: [
                  CardChiTietDoanhThuWidget(
                    tongdoanhthu: widget.tongdoanhthu,
                    thanhcong: widget.thanhcong,
                    dangcho: widget.dangcho,
                    huy: widget.huy,
                  ),
                  widget.loai == "Ngay"
                      ? TabbarChiTietDoanhThu(
                          allDonHangTrongNgay: allDonHangTrongNgay)
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Chi tiết hàng ngày",
                                    style: TextStyle(
                                        fontSize: Font.sizes(context)[2]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            StreamChiTietDoanhThuTuanThang(
                              controllerDoanhThu: controllerDoanhThu,
                              widget: widget.loai == "Tuan"
                                  ? widget.week
                                  : widget.ngay,
                              loai: widget.loai,
                            )
                          ],
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
