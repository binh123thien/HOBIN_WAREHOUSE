import 'package:flutter/material.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
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
          height: size.height * 0.12,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(5),
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
                Text(ngay, style: TextStyle(fontSize: Font.sizes(context)[1])),
                const SizedBox(height: 10),
                Text(formatCurrency(tongdoanhthu),
                    style: TextStyle(fontSize: Font.sizes(context)[2])),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image(
                        image: const AssetImage(doanhthuThanhCongIcon),
                        height: Font.sizes(context)[1]),
                    Text(
                      " $thanhcong đơn thành công",
                      style: TextStyle(fontSize: Font.sizes(context)[1]),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
