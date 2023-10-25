import 'package:flutter/material.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';

class CardThongKeDonHang extends StatelessWidget {
  const CardThongKeDonHang({
    super.key,
    required this.countThanhCong,
    required this.countDangCho,
    required this.countHuy,
    required this.daThanhToan,
    required this.no,
  });
  final String countThanhCong;
  final String countDangCho;
  final String countHuy;
  final String daThanhToan;
  final String no;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: mainColor,
            ),
            height: size.height * 0.2,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Thống kê đơn hàng",
                style: TextStyle(
                    fontSize: Font.sizes(context)[1], color: whiteColor),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            right: 1,
            child: Container(
              width: size.width,
              height: size.height * 0.16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: whiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hoàn thành",
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                        Text(countThanhCong,
                            style: TextStyle(fontSize: Font.sizes(context)[1]))
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đang sử lý",
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                        Text(countDangCho,
                            style: TextStyle(fontSize: Font.sizes(context)[1]))
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã hủy",
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                        Text(countHuy,
                            style: TextStyle(fontSize: Font.sizes(context)[1]))
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã thanh toán",
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                        Text(daThanhToan,
                            style: TextStyle(fontSize: Font.sizes(context)[1]))
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng còn nợ",
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                        Text(no,
                            style: TextStyle(
                                fontSize: Font.sizes(context)[1],
                                color: Colors.red))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
