import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../common_widgets/fontSize/font_size.dart';
import 'widget/bottom_bar_nhaphang.dart';
import 'widget/danhsach_items_dachon.dart';
import 'widget/formnhapso_nhaphang.dart';
import 'widget/nhapthongtin_item.dart';

class NhapHangScreen extends StatefulWidget {
  const NhapHangScreen({super.key});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
  final int phanBietNhap = 1;
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
          phanbietgianhapHoacSoluong: 'gianhap',
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemNhap["gia"] = num.tryParse(value)!;
          _checkFields();
        });
      }
    });
  }

  void _selectDate() {
    DateTime now = DateTime.now();
    showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: blueColor,
            colorScheme: const ColorScheme.light(primary: blueColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
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
          phanbietgianhapHoacSoluong: 'soluong',
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          thongTinItemNhap["soluong"] = num.tryParse(value)!;
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
          title: Text("Nhập hàng",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: Font.sizes(context)[2])),
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
