import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/chonsoluong_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/danhsach_items_dachon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/bottom_bar_xuathang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/xuatthongtin_item.dart';

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

  @override
  void initState() {
    super.initState();

    thongTinItemXuat = {
      "tonkho": "",
      "macode": "",
      "tensanpham": "",
      "location": listLocation,
      "exp": "",
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
        return ChonSoLuongWidget(
          phanBietNhapXuat: phanBietXuat,
        );
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

  void _reload(List<Map<String, dynamic>> selectedItems) {
    setState(() {
      allThongTinItemXuat = selectedItems;
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
            ),
            allThongTinItemXuat.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        PhanCachWidget.space(),
                        DanhSachItemsDaChonScreen(
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
        setDefaulseThongTinXuatHang: _setDefaulseThongTinNhapHang,
        thongTinItemXuat: thongTinItemXuat,
        checkFields: _checkFields,
        isButtonEnabled: isButtonEnabled,
        allThongTinItemXuat: allThongTinItemXuat,
      ),
    );
  }
}
