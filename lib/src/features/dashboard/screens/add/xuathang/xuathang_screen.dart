import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/chonsoluong_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/xuatthongtin_item.dart';

class XuatHangScreen extends StatefulWidget {
  const XuatHangScreen({super.key});

  @override
  State<XuatHangScreen> createState() => _XuatHangScreenState();
}

class _XuatHangScreenState extends State<XuatHangScreen> {
  List<Map<String, dynamic>> allThongTinItemNhap = [];
  Map<String, dynamic> thongTinItemNhap = {
    "macode": "",
    "tensanpham": "",
    "location": "",
    "exp": "",
    "soluong": 0,
    "gia": 0,
  };
  bool isButtonEnabled = false;
  // Hàm kiểm tra xem tất cả các trường đã có dữ liệu hay chưa
  void _checkFields() {
    if (thongTinItemNhap["tensanpham"].isNotEmpty &&
        thongTinItemNhap["soluong"] > 0) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  void _chonSoluong() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return const ChonSoLuongWidget();
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemNhap["soluong"] = int.tryParse(value);
          _checkFields();
        });
      }
    });
  }

  // void _setDefaulseThongTinNhapHang() {
  //   setState(() {
  //     thongTinItemNhap = {
  //       "macode": "",
  //       "tensanpham": "",
  //       "soluong": 0,
  //     };
  //   });
  // }

  // void _reload(List<Map<String, dynamic>> selectedItems) {
  //   setState(() {
  //     allThongTinItemNhap = selectedItems;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Xuất hàng", style: TextStyle(fontSize: 18)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            XuatThongTinItemXuatHangScreen(
              chonSoluong: _chonSoluong,
              thongTinItemNhap: thongTinItemNhap,
            )
          ],
        ),
      ),
      // bottomNavigationBar: BottomBarNhapHang(
      //   isButtonEnabled: isButtonEnabled,
      //   checkFields: _checkFields,
      //   allThongTinItemNhap: allThongTinItemNhap,
      //   thongTinItemNhap: thongTinItemNhap,
      //   setDefaulseThongTinNhapHang: _setDefaulseThongTinNhapHang,
      // ),
    );
  }
}
