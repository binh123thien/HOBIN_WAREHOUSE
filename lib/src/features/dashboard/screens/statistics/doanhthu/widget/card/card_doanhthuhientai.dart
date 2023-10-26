import 'package:flutter/material.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';
import '../chitiet_doanhthu_screen.dart';

class CardDoanThuHienTai extends StatelessWidget {
  const CardDoanThuHienTai({
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
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: Font.sizes(context)[1])),
        const SizedBox(height: 5),
        Text(formatCurrency(tongdoanhthu),
            style: TextStyle(fontSize: Font.sizes(context)[3])),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                    image: const AssetImage(doanhthuThanhCongIcon),
                    height: size.width * 0.045),
                Text(
                  " $thanhcong đơn thành công",
                  style: TextStyle(fontSize: Font.sizes(context)[1]),
                ),
              ],
            ),
            SizedBox(
              width: size.width * 0.27,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: mainColor,
                    side: const BorderSide(color: mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChiTietDoanhThuScreen(
                                ngay: ngay,
                                tongdoanhthu: tongdoanhthu,
                                thanhcong: thanhcong,
                                dangcho: dangcho,
                                huy: huy,
                                loai: phanloai == "Ngay"
                                    ? 'Ngay'
                                    : phanloai == "Tuan"
                                        ? "Tuan"
                                        : "Thang",
                                week: week,
                              )),
                    );
                  },
                  child: Text(
                    "Xem chi tiết",
                    style: TextStyle(
                        fontSize: Font.sizes(context)[1],
                        fontWeight: FontWeight.w700),
                  )),
            )
          ],
        )
      ],
    );
  }
}
