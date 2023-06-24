import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';

class TotalPriceWidget extends StatelessWidget {
  final int phanbietNhapXuat;
  const TotalPriceWidget({
    super.key,
    required this.sumItem,
    required this.sumPrice,
    required this.disCount,
    required this.showDiscount,
    required this.phanbietNhapXuat,
  });

  final num sumItem;
  final num sumPrice;
  final num disCount;
  final VoidCallback showDiscount;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: darkColor.withOpacity(0.1)),
          color: whiteColor,
        ),
        width: size.width,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tóm tắt thanh toán",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tổng số lượng: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Text(sumItem.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng tiền: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(
                    NumberFormat.currency(
                      locale: "vi",
                      symbol: "",
                      decimalDigits: 0,
                    ).format(sumPrice),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: showDiscount,
                    child: Row(
                      children: [
                        Text("Giảm giá: ",
                            style: TextStyle(
                                fontSize: 17,
                                color: phanbietNhapXuat == 0
                                    ? cancelColor
                                    : success600Color)),
                        Icon(
                          Icons.draw,
                          color: phanbietNhapXuat == 0
                              ? cancelColor
                              : success600Color,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: "vi",
                      symbol: "",
                      decimalDigits: 0,
                    ).format(disCount),
                    style: TextStyle(
                        color: phanbietNhapXuat == 0
                            ? cancelColor
                            : success600Color,
                        fontSize: 17),
                  )
                ],
              ),
              const SizedBox(height: 6),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng thanh toán: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(
                    NumberFormat.currency(
                      locale: "vi",
                      symbol: "",
                      decimalDigits: 0,
                    ).format(sumPrice - disCount),
                    style: TextStyle(
                        fontSize: 17,
                        color: phanbietNhapXuat == 0
                            ? success600Color
                            : cancel600Color),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
