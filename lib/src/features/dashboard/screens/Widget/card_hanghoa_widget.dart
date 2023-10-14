import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

import '../../../../utils/utils.dart';

class CardHangHoa extends StatelessWidget {
  const CardHangHoa({
    super.key,
    required this.hanghoa,
    required this.onTapChiTietHangHoa,
  });
  final dynamic hanghoa;

  final VoidCallback onTapChiTietHangHoa;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black),
            color: whiteColor),
        child: ListTile(
          onTap: onTapChiTietHangHoa,
          leading: hanghoa["photoGood"].isEmpty
              ? const Image(
                  image: AssetImage(hanghoaIcon),
                  height: 35,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 40,
                    width: 40,
                    imageUrl: hanghoa["photoGood"].toString(),
                    fit: BoxFit.fill,
                  ),
                ),
          title: Text(
            hanghoa["tensanpham"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatCurrency(hanghoa["giaban"]),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                "Bán: ${hanghoa["daban"]} ${hanghoa["donvi"]}",
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          subtitle: Text(
            "Kho: ${hanghoa["tonkho"]} ${hanghoa["donvi"]}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
            textAlign: TextAlign.start,
          ),
          dense: true,
        ),
      ),
    );
  }
}
