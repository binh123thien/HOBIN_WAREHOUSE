import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../utils/utils.dart';

class ChitietThang extends StatelessWidget {
  final String phanbietNhapHangBanHang;
  const ChitietThang({
    super.key,
    required this.doanhThuMonthlyTotal,
    required this.soluongMonthlyTotal,
    required this.soLuongDonHangMonthlyTotal,
    required this.phanbietNhapHangBanHang,
  });

  final num doanhThuMonthlyTotal;
  final num soluongMonthlyTotal;
  final int soLuongDonHangMonthlyTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                backgroundColor: greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(
                  phanbietNhapHangBanHang == "XuatHang"
                      ? "Tổng thu: ${formatCurrency(doanhThuMonthlyTotal)}"
                      : "Tổng chi: ${formatCurrency(doanhThuMonthlyTotal)}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(width: 5),
              Chip(
                backgroundColor: greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(
                  phanbietNhapHangBanHang == "XuatHang"
                      ? "Đã bán: $soluongMonthlyTotal"
                      : "Đã nhập: $soluongMonthlyTotal",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(width: 5),
              Chip(
                backgroundColor: greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(
                  "Đơn hàng: $soLuongDonHangMonthlyTotal",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
              )
            ],
          ),
        ));
  }
}
