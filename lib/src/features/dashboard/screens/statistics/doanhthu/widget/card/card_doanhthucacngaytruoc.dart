import 'package:flutter/material.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';

class CardDoanhThuCacNgayTruoc extends StatelessWidget {
  const CardDoanhThuCacNgayTruoc({
    super.key,
    required this.ngay,
    required this.tongdoanhthu,
    required this.thanhcong,
  });

  final String ngay;
  final num tongdoanhthu;
  final int thanhcong;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
          width: size.width - 35,
          height: 100,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: backGround600Color.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ngay, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Text(formatCurrency(tongdoanhthu),
                    style: const TextStyle(fontSize: 19)),
                const SizedBox(height: 10),
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
              ],
            ),
          )),
    );
  }
}
