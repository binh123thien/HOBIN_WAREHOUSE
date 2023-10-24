import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
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
    required this.trangthai,
  });
  final String trangthai;
  final String khachhang;
  final num no;
  final num tongtien;
  final String date;
  final String bHcode;
  final String billType;
  final String paymentSelected;
  @override
  Widget build(BuildContext context) {
    handleIconTieuDe() {
      //success
      if (billType == "XuatHang" && trangthai == "Thành công") {
        return xuathangIcon;
      }
      if (billType == "NhapHang" && trangthai == "Thành công") {
        return nhaphangIcon;
      }
      if (billType == "HetHan" && trangthai == "Thành công") {
        return hethanIcon;
      }
      //pending
      if (trangthai == "Đang chờ") {
        return dangchoIcon;
      }
      //cancel
      if (trangthai == "Hủy") {
        return huyIcon;
      } else {
        return xuathangIcon;
      }
    }

    handleTextTieuDe() {
      if (billType == "XuatHang" && trangthai != "Hủy") {
        return "Xuất Hàng thành công";
      }
      if (billType == "NhapHang" && trangthai != "Hủy") {
        return "Nhập hàng thành công";
      }
      if (trangthai == "Hủy") {
        return "Đơn hàng đã bị hủy";
      } else {
        return "Đơn hàng không xác định";
      }
    }

    handleColorPriceTieuDe() {
      if (billType == "XuatHang" && trangthai != "Hủy") {
        return success600Color;
      }
      if (billType == "NhapHang" && trangthai != "Hủy") {
        return cancel600Color;
      } else {
        return mainColor;
      }
    }

    final size = MediaQuery.of(context).size;
    return Container(
      color: whiteColor,
      width: size.width,
      height: 255,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage(handleIconTieuDe()),
                    height: 45,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(handleTextTieuDe(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                    Text(
                      NumberFormat.currency(
                        locale: "vi",
                        symbol: "đ",
                        decimalDigits: 0,
                      ).format(tongtien),
                      style: TextStyle(
                          fontSize: 17, color: handleColorPriceTieuDe()),
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
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: trangthai == "Thành công"
                              ? successColor
                              : trangthai == "Đang chờ"
                                  ? processColor
                                  : cancel600Color),
                      color: whiteColor,
                    ),
                    width: 95,
                    height: 28,
                    child: Align(
                      alignment: Alignment.center,
                      child: trangthai == "Thành công"
                          ? const Text(
                              "Thành công",
                              style:
                                  TextStyle(fontSize: 14, color: successColor),
                            )
                          : trangthai == "Đang chờ"
                              ? const Text(
                                  "Đang chờ",
                                  style: TextStyle(
                                      fontSize: 14, color: processColor),
                                )
                              : const Text(
                                  "Hủy",
                                  style: TextStyle(
                                      fontSize: 14, color: cancel600Color),
                                ),
                    ))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Thời gian:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(date,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: PhanCachWidget.dotLine(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Số HD:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(bHcode,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(billType == "XuatHang" ? "Khách hàng:" : "Nhà cùng cấp:",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text(khachhang,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Hình thức thanh toán:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(paymentSelected,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
