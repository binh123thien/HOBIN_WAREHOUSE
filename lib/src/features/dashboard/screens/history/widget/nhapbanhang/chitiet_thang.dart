import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text(
                  phanbietNhapHangBanHang == "BanHang"
                      ? "Tổng thu: ${formatCurrency(doanhThuMonthlyTotal)}"
                      : "Tổng chi: ${formatCurrency(doanhThuMonthlyTotal)}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(width: 5),
              Chip(
                label: Text(
                  phanbietNhapHangBanHang == "BanHang"
                      ? "Đã bán: $soluongMonthlyTotal"
                      : "Đã nhập: $soluongMonthlyTotal",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(width: 5),
              Chip(
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
