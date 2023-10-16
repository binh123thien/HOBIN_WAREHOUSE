import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../history/widget/card_history.dart';
import 'khachhang_card_thongkedonhang.dart';
import 'khachhang_thongtincanhan.dart';

class ThongTinKhachHang extends StatefulWidget {
  final dynamic khachhang;
  const ThongTinKhachHang({super.key, this.khachhang});

  @override
  State<ThongTinKhachHang> createState() => _ThongTinKhachHangState();
}

class _ThongTinKhachHangState extends State<ThongTinKhachHang> {
  final KhachHangController controller = Get.find();

  List<dynamic> allDonHang = [];
  List<dynamic> allDonHangCurent = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    allDonHang = widget.khachhang["loai"] == "Nhà cung cấp"
        ? controller.allDonNhapHangFirebase
        : controller.allDonBanHangFirebase;
    allDonHangCurent = allDonHang
        .where((doc) => doc["khachhang"] == widget.khachhang["tenkhachhang"])
        .toList();
    allDonHangCurent.sort((a, b) => b['soHD'].compareTo(a['soHD']));
  }

  @override
  Widget build(BuildContext context) {
    final int countThanhCong = allDonHangCurent
        .where((doc) => doc["trangthai"] == "Thành công")
        .length;
    final int countDangCho =
        allDonHangCurent.where((doc) => doc["trangthai"] == "Đang chờ").length;
    final int countHuy =
        allDonHangCurent.where((doc) => doc["trangthai"] == "Hủy").length;
    final num daThanhToan = allDonHangCurent.isNotEmpty
        ? allDonHangCurent
            .map((doc) => doc["tongthanhtoan"])
            .reduce((value, element) => value + element)
        : 0;
    final num no = allDonHangCurent.isNotEmpty
        ? allDonHangCurent
            .map((doc) => doc["no"])
            .reduce((value, element) => value + element)
        : 0;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        ThongTinCaNhan(khachhang: widget.khachhang),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return CardThongKeDonHang(
              countThanhCong: countThanhCong.toString(),
              countDangCho: countDangCho.toString(),
              countHuy: countHuy.toString(),
              daThanhToan: formatCurrency(daThanhToan),
              no: formatCurrency(no),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: mainColor,
            ),
            height: 35,
            width: size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Đơn đã bán",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(5)),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: ((BuildContext context, int index) {
                return allDonHangCurent.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        color: whiteColor,
                        child: Column(
                          children: [
                            CardHistory(
                              docs: allDonHangCurent,
                            )
                          ],
                        ),
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Chưa có đơn hàng nào!",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
              }),
            ),
          ),
        )
      ],
    );
  }
}
