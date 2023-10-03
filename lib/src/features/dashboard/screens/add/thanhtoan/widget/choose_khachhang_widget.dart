import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../constants/icon.dart';
import '../choose_khachhang_thanhtoan_screen.dart';

class ChooseKhachHangWidget extends StatefulWidget {
  final String phanbietnhapxuat;
  final Map<String, dynamic> khachhang;
  final Function reload;
  const ChooseKhachHangWidget(
      {super.key,
      required this.khachhang,
      required this.reload,
      required this.phanbietnhapxuat});

  @override
  State<ChooseKhachHangWidget> createState() => _ChooseKhachHangWidgetState();
}

class _ChooseKhachHangWidgetState extends State<ChooseKhachHangWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const ChooseKhachHangThanhToanScreen()),
        ).then((value) {
          if (value != null) {
            widget.reload(value);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: Image(image: AssetImage(khachHangThanhToanIcon)),
                ),
                const SizedBox(width: 7),
                widget.khachhang.isEmpty
                    ? widget.phanbietnhapxuat == "nhaphang"
                        ? const Text(
                            "Nhà Cung Cấp",
                            style: TextStyle(fontSize: 17),
                          )
                        : const Text(
                            "Khách hàng",
                            style: TextStyle(fontSize: 17),
                          )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.khachhang["tenkhachhang"],
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.khachhang["sdt"],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
