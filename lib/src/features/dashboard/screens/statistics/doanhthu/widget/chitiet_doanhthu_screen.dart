import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../constants/color.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';
import 'card_chitietdoanhthu.dart';
import 'doanhthutheongay/tabbar_doanhthutheongay.dart';

class ChiTietDoanhThuScreen extends StatefulWidget {
  final String ngay;
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
      required this.huy});

  @override
  State<ChiTietDoanhThuScreen> createState() => _ChiTietDoanhThuScreenState();
}

class _ChiTietDoanhThuScreenState extends State<ChiTietDoanhThuScreen> {
  final KhachHangController controller = Get.find();

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: whiteColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.ngay,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: whiteColor)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Stack(
            children: [
              Container(
                height: 100,
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
                  TabbarChiTietDoanhThu(
                      allDonHangTrongNgay: allDonHangTrongNgay)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
