import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';

class NoWidget extends StatelessWidget {
  final int phanbietNhapXuat;
  const NoWidget({
    super.key,
    required this.onTapShowNo,
    required this.no,
    required this.phanbietNhapXuat,
  });

  final num no;
  final VoidCallback onTapShowNo;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: darkColor.withOpacity(0.1)),
          color: whiteColor,
        ),
        width: size.width,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTapShowNo,
                child: Row(
                  children: [
                    const Text(
                      "Nợ: (nếu có)",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.draw,
                        color: phanbietNhapXuat == 0
                            ? cancelColor
                            : success600Color),
                  ],
                ),
              ),
              Text(
                NumberFormat.currency(
                  locale: "vi",
                  symbol: "",
                  decimalDigits: 0,
                ).format(no),
                style: TextStyle(
                    color:
                        phanbietNhapXuat == 0 ? cancelColor : success600Color,
                    fontSize: 17),
              )
            ],
          ),
        ),
      ),
    );
  }
}
