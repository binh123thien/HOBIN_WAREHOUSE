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
    return Card(
      color: whiteColor,
      elevation: 2,
      child: SizedBox(
        width: size.width - 30,
        height: 210,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Thống kê đơn hàng",
                style: TextStyle(fontSize: 18),
              ),
              const Divider(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Hoàn thành", style: TextStyle(fontSize: 18)),
                      Text(countThanhCong,
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Đang xử lý", style: TextStyle(fontSize: 18)),
                      Text(countDangCho, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Đã hủy", style: TextStyle(fontSize: 18)),
                      Text(countHuy, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Đã thanh toán",
                          style: TextStyle(fontSize: 18)),
                      Text(daThanhToan, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng còn nợ", style: TextStyle(fontSize: 18)),
                      Text(no,
                          style: const TextStyle(
                              fontSize: 18, color: cancelColor)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
