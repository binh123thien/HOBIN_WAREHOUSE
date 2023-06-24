import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';

class BottomBarThanhToan extends StatelessWidget {
  final int phanbietNhapXuat;
  const BottomBarThanhToan({
    super.key,
    required this.paymentSelected,
    required this.sumPrice,
    required this.disCount,
    required this.no,
    required this.onTapPaynemtSelection,
    required this.onPressedThanhToan,
    required this.phanbietNhapXuat,
  });
  final int paymentSelected;
  final num sumPrice;
  final num disCount;
  final num no;
  final VoidCallback onTapPaynemtSelection;
  final VoidCallback onPressedThanhToan;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      height: 120,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          paymentSelected == 0
                              ? Icons.paid
                              : paymentSelected == 1
                                  ? Icons.account_balance
                                  : Icons.account_balance_wallet,
                          size: 28,
                          color: success600Color,
                        )),
                    Text(
                      paymentSelected == 0
                          ? "Tiền mặt: "
                          : paymentSelected == 1
                              ? "Chuyển khoản: "
                              : "Ví điện tử: ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                        NumberFormat.currency(
                          locale: "vi",
                          symbol: "",
                          decimalDigits: 0,
                        ).format(sumPrice - disCount - no),
                        style: TextStyle(
                            fontSize: 16,
                            color: phanbietNhapXuat == 0
                                ? success600Color
                                : cancel600Color)),
                  ],
                ),
                GestureDetector(
                    onTap: onTapPaynemtSelection,
                    // _showHinhThucThanhToan,
                    child: const Icon(Icons.more_vert)),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      phanbietNhapXuat == 0 ? mainColor : blueColor,
                  side: BorderSide(
                      color: phanbietNhapXuat == 0 ? mainColor : blueColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25), // giá trị này xác định bán kính bo tròn
                  ),
                ),
                onPressed: onPressedThanhToan,
                child: const Text(
                  "Thanh Toán",
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
