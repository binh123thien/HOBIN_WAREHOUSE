import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/bottom_bar_xuathang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/xuathang/widget/xuatthongtin_item.dart';

import '../../../controllers/add/chonhanghoa_controller.dart';
import '../nhaphang/widget/formnhapso_nhaphang.dart';
import 'widget/chonsoluong_xuathang_widget.dart';
import 'widget/danhsach_xuathang_screen.dart';

class XuatHangScreen extends StatefulWidget {
  const XuatHangScreen({super.key});

  @override
  State<XuatHangScreen> createState() => _XuatHangScreenState();
}

class _XuatHangScreenState extends State<XuatHangScreen> {
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
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

  void _thayDoiGia() {
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return FormNhapSoNhapHangWidget(
          focusNode: focusNode,
          phanbietgianhapHoacSoluong: 'giaxuat',
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemXuat["gia"] = num.tryParse(value)!;
          _checkFields();
        });
      }
    });
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

  void _reLoadOnDeleteXuatHang(
      List<Map<String, dynamic>> selectedItems, String macode, num soluong) {
    setState(() {
      for (var doc in controllerAllHangHoa.allHangHoaFireBase) {
        if (doc["macode"] == macode) {
          doc["tonkho"] = doc["tonkho"] + soluong;
        }
      }
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
              thayDoiGia: _thayDoiGia,
            ),
            allThongTinItemXuat.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        PhanCachWidget.space(),
                        DanhSachXuatHangWidget(
                          selectedItems: allThongTinItemXuat,
                          blockOnPress: false,
                          reLoadOnDeleteXuatHang: _reLoadOnDeleteXuatHang,
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
