import 'package:flutter/material.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import 'widget/choose_khachhang_widget.dart';

class ThanhToanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemNhap;
  const ThanhToanScreen({super.key, required this.allThongTinItemNhap});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  Map<String, dynamic> khachhang = {};

  void _reload(Map<String, dynamic> khachhangPicked) {
    setState(() {
      khachhang = khachhangPicked;
    });
  }

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
          ChooseKhachHangWidget(
            khachhang: khachhang,
            reload: _reload,
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
