import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../utils/utils.dart';

// ignore: must_be_immutable
class TotalPriceChiTietDonHangWidget extends StatelessWidget {
  const TotalPriceChiTietDonHangWidget({
    super.key,
    required this.sumItem,
    required this.sumPrice,
    required this.disCount,
    required this.tienno,
    required this.billType,
  });

  final num sumItem;
  final num sumPrice;
  final num disCount;
  final num tienno;
  final String billType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: whiteColor,
        ),
        width: size.width,
        height: 195,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Chi tiết thanh toán",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng số lượng: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(sumItem.toString(),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng tiền: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(
                    formatCurrency(sumPrice),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Giảm giá: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(formatCurrency(disCount),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng thanh toán: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(
                    formatCurrency(sumPrice - disCount),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(billType == "BanHang" ? "Khách nợ:" : "Nợ nhà cung cấp:",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(
                    formatCurrency(tienno),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: cancel600Color),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
