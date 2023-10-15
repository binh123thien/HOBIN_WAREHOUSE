import 'package:flutter/material.dart';

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
            height: 175,
            width: size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Thống kê đơn hàng",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            right: 1,
            child: Container(
              width: size.width - 10,
              height: 140,
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
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(countThanhCong,
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đang sử lý",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(countDangCho,
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã hủy",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(countHuy,
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã thanh toán",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(daThanhToan,
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng còn nợ",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(no,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16))
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
