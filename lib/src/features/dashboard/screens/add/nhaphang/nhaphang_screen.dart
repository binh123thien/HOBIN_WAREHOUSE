import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import 'widget/bottom_bar_nhaphang.dart';
import 'widget/chonsoluong_widget.dart';
import 'widget/danhsach_items_dachon.dart';
import 'widget/nhapthongtin_item.dart';
import 'widget/thaydoigia_widget.dart';

class NhapHangScreen extends StatefulWidget {
  const NhapHangScreen({super.key});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
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
        thongTinItemNhap["location"].isNotEmpty &&
        thongTinItemNhap["exp"].isNotEmpty &&
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

  void _thayDoiGia() {
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
        return const ThayDoiGiaWidget();
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemNhap["gia"] = int.tryParse(value);
        });
      }
    });
  }

  void _selectDate() {
    DateTime now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    ).then((picked) {
      if (picked != null) {
        setState(() {
          thongTinItemNhap["exp"] = DateFormat('dd/MM/yyyy').format(picked);
          _checkFields();
        });
      }
    });
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

  void _setDefaulseThongTinNhapHang() {
    setState(() {
      thongTinItemNhap = {
        "macode": "",
        "tensanpham": "",
        "location": "",
        "exp": "",
        "soluong": 0,
        "gia": 0,
      };
    });
  }

  void _reload(List<Map<String, dynamic>> selectedItems) {
    setState(() {
      allThongTinItemNhap = selectedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Nhập hàng", style: TextStyle(fontSize: 18)),
          backgroundColor: blueColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NhapThongTinItemScreen(
                thongTinItemNhap: thongTinItemNhap,
                checkFields: _checkFields,
                selectDate: _selectDate,
                chonSoluong: _chonSoluong,
                thayDoiGia: _thayDoiGia,
              ),
              allThongTinItemNhap.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          PhanCachWidget.space(),
                          DanhSachItemsDaChonScreen(
                            selectedItems: allThongTinItemNhap,
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
        bottomNavigationBar: BottomBarNhapHang(
          isButtonEnabled: isButtonEnabled,
          checkFields: _checkFields,
          allThongTinItemNhap: allThongTinItemNhap,
          thongTinItemNhap: thongTinItemNhap,
          setDefaulseThongTinNhapHang: _setDefaulseThongTinNhapHang,
        ));
  }
}
