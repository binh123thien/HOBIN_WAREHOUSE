import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../controllers/statistics/doanhthu_controller.dart';
import '../card_chitietdoanhthu.dart';

class ChiTietDoanhThuTheoTuanScreen extends StatefulWidget {
  final String ngay;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;
  const ChiTietDoanhThuTheoTuanScreen(
      {super.key,
      required this.ngay,
      required this.tongdoanhthu,
      required this.thanhcong,
      required this.dangcho,
      required this.huy});

  @override
  State<ChiTietDoanhThuTheoTuanScreen> createState() =>
      _ChiTietDoanhThuTheoTuanScreenState();
}

class _ChiTietDoanhThuTheoTuanScreenState
    extends State<ChiTietDoanhThuTheoTuanScreen> {
  final controllerDoanhThu = DoanhThuController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.ngay,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: whiteColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Column(
            children: [
              CardChiTietDoanhThuWidget(
                tongdoanhthu: widget.tongdoanhthu,
                thanhcong: widget.thanhcong,
                dangcho: widget.dangcho,
                huy: widget.huy,
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text("Chi tiết hàng ngày"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
