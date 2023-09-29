import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import 'widget/choose_khachhang_thanhtoan_screen.dart';

class ThanhToanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemNhap;
  const ThanhToanScreen({super.key, required this.allThongTinItemNhap});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 1,
        title: Text("Thanh Toán (${widget.allThongTinItemNhap.length})",
            style: const TextStyle(fontSize: 18, color: Colors.black)),
        backgroundColor: whiteColor,
        leading: IconButton(
            icon: const Image(
              image: AssetImage(backIcon),
              height: 17,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const ChooseKhachHangThanhToanScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
              child: Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              Image(image: AssetImage(khachHangThanhToanIcon)),
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Nhà Cung Cấp",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 10,
            color: greyColor,
          )
        ],
      ),
    );
  }
}
