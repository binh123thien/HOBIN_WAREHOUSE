import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:intl/intl.dart';

class TieuDeChiTietDonHang extends StatelessWidget {
  const TieuDeChiTietDonHang({
    super.key,
    required this.tongtien,
    required this.date,
    required this.bHcode,
    required this.paymentSelected,
    required this.no,
    required this.khachhang,
    required this.billType,
  });
  final String khachhang;
  final num no;
  final num tongtien;
  final String date;
  final String bHcode;
  final String billType;
  final int paymentSelected;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: whiteColor),
        width: size.width,
        height: 260,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 45,
                    child: Image(
                      image: AssetImage(billType == "BanHang" && no == 0
                          ? banhangIcon
                          : billType == "NhapHang" && no == 0
                              ? nhaphangIcon
                              : dangchoIcon),
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          billType == "BanHang"
                              ? "Bán Hàng thành công"
                              : "Nhập hàng thành công",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      Text(
                        NumberFormat.currency(
                          locale: "vi",
                          symbol: "đ",
                          decimalDigits: 0,
                        ).format(tongtien),
                        style: TextStyle(
                            fontSize: 17,
                            color: billType == "BanHang"
                                ? success600Color
                                : cancel600Color),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Trạng thái: ",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: no == 0 ? successColor : processColor,
                    ),
                    width: 95,
                    height: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        no == 0 ? "Thành công" : "Đang chờ",
                        style: const TextStyle(fontSize: 14, color: whiteColor),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Thời gian:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(date,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Số HD:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(bHcode,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(billType == "BanHang" ? "Khách hàng:" : "Nhà cùng cấp:",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(khachhang,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hình thức thanh toán:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  Text(
                      paymentSelected == 0
                          ? "Tiền mặt"
                          : paymentSelected == 1
                              ? "Chuyển khoản"
                              : "Ví điện tử",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
