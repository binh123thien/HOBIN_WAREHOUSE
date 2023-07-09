import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';
import 'chitiet_doanhthu_screen.dart';
import 'doanhthutheothang/chitietdoanhthu_theothang.dart';
import 'doanhthutheotuan/chitietdoanhthu_theotuan.dart';

class DoanhThuTieuDe extends StatelessWidget {
  const DoanhThuTieuDe({
    super.key,
    required this.tongdoanhthu,
    required this.thanhcong,
    required this.title,
    required this.dangcho,
    required this.huy,
    required this.ngay,
    required this.phanloai,
    required this.week,
  });
  final String phanloai;
  final String ngay;
  final String week;
  final String title;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 5),
        Text(formatCurrency(tongdoanhthu),
            style: const TextStyle(fontSize: 19)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Image(
                    image: AssetImage(doanhthuThanhCongIcon), height: 15),
                Text(
                  " $thanhcong đơn thành công",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: mainColor,
                    side: const BorderSide(color: mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => phanloai == "ngay"
                              ? ChiTietDoanhThuScreen(
                                  ngay: ngay,
                                  tongdoanhthu: tongdoanhthu,
                                  thanhcong: thanhcong,
                                  dangcho: dangcho,
                                  huy: huy,
                                )
                              : phanloai == "tuan"
                                  ? ChiTietDoanhThuTheoTuanScreen(
                                      week: week,
                                      ngay: ngay,
                                      tongdoanhthu: tongdoanhthu,
                                      thanhcong: thanhcong,
                                      dangcho: dangcho,
                                      huy: huy,
                                    )
                                  : ChiTietDoanhThuTheoThangScreen(
                                      ngay: ngay,
                                      tongdoanhthu: tongdoanhthu,
                                      thanhcong: thanhcong,
                                      dangcho: dangcho,
                                      huy: huy,
                                    )),
                    );
                  },
                  child: const Text(
                    "Xem chi tiết",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  )),
            )
          ],
        )
      ],
    );
  }
}
