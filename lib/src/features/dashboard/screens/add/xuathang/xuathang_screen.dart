import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/chonsoluong_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/bottom_bar_xuathang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/xuatthongtin_item.dart';

class XuatHangScreen extends StatefulWidget {
  const XuatHangScreen({super.key});

  @override
  State<XuatHangScreen> createState() => _XuatHangScreenState();
}

class _XuatHangScreenState extends State<XuatHangScreen> {
  List<Map<String, dynamic>> allThongTinItemXuat = [];
  Map<String, dynamic> thongTinItemXuat = {
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
    if (thongTinItemXuat["tensanpham"].isNotEmpty &&
        thongTinItemXuat["soluong"] > 0) {
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
          thongTinItemXuat["soluong"] = int.tryParse(value);
          _checkFields();
        });
      }
    });
  }

  void _setDefaulseThongTinNhapHang() {
    setState(() {
      thongTinItemXuat = {
        "macode": "",
        "tensanpham": "",
        "soluong": 0,
      };
    });
  }

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
              thongTinItemXuat: thongTinItemXuat,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBarXuatHang(
        setDefaulseThongTinXuatHang: _setDefaulseThongTinNhapHang,
        thongTinItemXuat: thongTinItemXuat,
        checkFields: _checkFields,
        isButtonEnabled: isButtonEnabled,
        allThongTinItemXuat: allThongTinItemXuat,
      ),
    );
  }
}
