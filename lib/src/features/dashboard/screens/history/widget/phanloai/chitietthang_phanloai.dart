import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../utils/utils.dart';

class ChitietThangPhanLoai extends StatelessWidget {
  const ChitietThangPhanLoai({
    super.key,
    required this.tongBanHangMonthly,
    required this.tongNhapHangMonthly,
  });

  final num tongBanHangMonthly;
  final num tongNhapHangMonthly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                    color: mainColor, width: 1.5), // Màu và độ dày của viền
              ),
              label: Text(
                "Tổng thu: ${formatCurrency(tongBanHangMonthly)}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(width: 5),
            Chip(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                    color: mainColor, width: 1.5), // Màu và độ dày của viền
              ),
              label: Text(
                "Tổng chi: ${formatCurrency(tongNhapHangMonthly)}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
