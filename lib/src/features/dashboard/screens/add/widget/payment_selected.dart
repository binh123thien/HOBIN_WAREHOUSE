import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

class PaymentSelected extends StatelessWidget {
  const PaymentSelected({
    super.key,
    required this.paymentSelected,
    required this.showHinhThucThanhToan,
  });

  final int paymentSelected;
  final VoidCallback showHinhThucThanhToan;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: whiteColor,
      width: size.width,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Image(image: AssetImage(cashIcon), height: 22),
                const SizedBox(width: 8),
                Text(
                  "Hình thức thanh toán",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: showHinhThucThanhToan,
            child: SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      paymentSelected == 0
                          ? "Tiền mặt"
                          : paymentSelected == 1
                              ? "Chuyển khoản"
                              : "Ví điện tử",
                      style: Theme.of(context).textTheme.bodySmall),
                  const Icon(Icons.expand_more),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
