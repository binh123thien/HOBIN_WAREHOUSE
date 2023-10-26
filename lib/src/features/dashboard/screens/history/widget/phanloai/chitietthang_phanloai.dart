import 'package:flutter/material.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Chip(
                backgroundColor: greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  "Tổng thu: ${formatCurrency(tongBanHangMonthly)}",
                  style: TextStyle(
                      fontSize: Font.sizes(context)[1],
                      fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(width: 5),
              Chip(
                backgroundColor: greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  "Tổng chi: ${formatCurrency(tongNhapHangMonthly)}",
                  style: TextStyle(
                      fontSize: Font.sizes(context)[1],
                      fontWeight: FontWeight.w100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
