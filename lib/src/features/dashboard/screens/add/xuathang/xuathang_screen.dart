import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/bottom_bar_xuathang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/xuatthongtin_item.dart';

import 'widget/chonsoluong_xuathang_widget.dart';
import 'widget/danhsachitemdachon_xuathang_screen.dart';

class XuatHangScreen extends StatefulWidget {
  const XuatHangScreen({super.key});

  @override
  State<XuatHangScreen> createState() => _XuatHangScreenState();
}

class _XuatHangScreenState extends State<XuatHangScreen> {
  final int phanBietXuat = 0;
  List<Map<String, dynamic>> allThongTinItemXuat = [];
  List<Map<String, dynamic>> listLocation = [];
  Map<String, dynamic> thongTinItemXuat = {};
  bool blockSoLuong = true;
  @override
  void initState() {
    super.initState();

    thongTinItemXuat = {
      "tonkho": 0,
      "macode": "",
      "tensanpham": "",
      "locationAndexp": listLocation,
      "soluong": 0,
      "gia": 0,
    };
  }

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
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return ChonSoLuongXuatHangWidget(
          focusNode: focusNode,
          tonkho: thongTinItemXuat["tonkho"],
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemXuat["soluong"] = num.tryParse(value)!;
          _checkFields();
        });
      }
    });
  }

  void _setDefaulseThongTinXuatHang() {
    setState(() {
      thongTinItemXuat = {
        "tonkho": 0,
        "macode": "",
        "tensanpham": "",
        "locationAndexp": [],
        "soluong": 0,
        "gia": 0,
      };
    });
  }

  void _reload(List<Map<String, dynamic>> selectedItems) {
    setState(() {
      allThongTinItemXuat = selectedItems;
    });
  }

  void _changeStateBlockSoluong() {
    setState(() {
      blockSoLuong = !blockSoLuong;
    });
  }

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
              checkFields: _checkFields,
              blockSoLuong: blockSoLuong,
              changeStateBlockSoluong: _changeStateBlockSoluong,
            ),
            allThongTinItemXuat.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        PhanCachWidget.space(),
                        DanhSachItemDaChonXuatHangScreen(
                          selectedItems: allThongTinItemXuat,
                          blockOnPress: false,
                          reLoad: _reload,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarXuatHang(
        setDefaulseThongTinXuatHang: _setDefaulseThongTinXuatHang,
        thongTinItemXuat: thongTinItemXuat,
        isButtonEnabled: isButtonEnabled,
        allThongTinItemXuat: allThongTinItemXuat,
        checkFields: _checkFields,
        changeStateBlockSoluong: _changeStateBlockSoluong,
      ),
    );
  }
}
