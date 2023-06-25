import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';

class CardChiTietDoanhThuWidget extends StatelessWidget {
  const CardChiTietDoanhThuWidget({
    super.key,
    required this.ngay,
    required this.tongdoanhthu,
    required this.thanhcong,
    required this.dangcho,
    required this.huy,
  });

  final String ngay;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: size.width - 24,
        height: 160,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: backGround600Color.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ngay, style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Image(image: AssetImage(soluongdonIcon), height: 15),
                      Text(
                        " Đơn thành công",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    " $thanhcong",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Image(image: AssetImage(soluongdonIcon), height: 15),
                      Text(
                        " Đơn đang chờ",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    " $dangcho",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Image(image: AssetImage(soluongdonIcon), height: 15),
                      Text(
                        " Đơn hủy",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    " $huy",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng doanh thu", style: TextStyle(fontSize: 17)),
                  Text(formatCurrency(tongdoanhthu),
                      style: const TextStyle(fontSize: 17)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
