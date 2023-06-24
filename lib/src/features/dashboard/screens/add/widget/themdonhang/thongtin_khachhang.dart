import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
// class ThongTinKhachHang extends StatelessWidget {
//    final int phanbietNhapXuat;
//   const ThongTinKhachHang({super.key, required this.phanbietNhapXuat, required this.showKhachHang, required this.khachHangSelected, required this.onUpdateKhachhang}) {
//   }
// final VoidCallback showKhachHang;
//   final String khachHangSelected;
//   final void Function(String newKhachHangSelected) onUpdateKhachhang;
//   late String newKhachHangSelected;

// }

class ThongTinKhachHang extends StatelessWidget {
  const ThongTinKhachHang(
      {super.key,
      required this.phanbietNhapXuat,
      required this.showKhachHang,
      required this.khachHangSelected,
      required this.onDeleteKhachhang});
  final int phanbietNhapXuat;
  final VoidCallback showKhachHang;
  final String khachHangSelected;
  final void Function(String newKhachHangSelected) onDeleteKhachhang;
  @override
  Widget build(BuildContext context) {
    String khachHangMatDinh;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: phanbietNhapXuat == 0 ? mainColor : blueColor,
            ),
            height: 85,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Text(
                phanbietNhapXuat == 0
                    ? "Thông tin khách hàng"
                    : "Thông tin nhà cung cấp",
                style: const TextStyle(fontSize: 16, color: whiteColor),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width - 10,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: whiteColor,
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 40,
                          ),
                        ),
                      ),
                      Text(
                        khachHangSelected,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      khachHangSelected != "Khách hàng" &&
                              khachHangSelected != "Nhà cung cấp"
                          ? GestureDetector(
                              onTap: () {
                                if (phanbietNhapXuat == 0) {
                                  khachHangMatDinh = "Khách hàng";
                                } else {
                                  khachHangMatDinh = "Nhà cung cấp";
                                }
                                onDeleteKhachhang(khachHangMatDinh);
                                // Thay đổi trạng thái của ứng dụng ở đây
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: cancel600Color,
                              ),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: showKhachHang,
                            icon: Image(
                              image: AssetImage(phanbietNhapXuat == 0
                                  ? morepinkIcon
                                  : moreblueIcon),
                              height: 28,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
