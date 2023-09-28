import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';
import 'widget/chonsoluong_widget.dart';
import 'widget/danhsach_items_dachon.dart';
import 'widget/nhapthongtin_item.dart';

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

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        showCloseIcon: true,
        closeIconColor: whiteColor,
        backgroundColor: successColor,
        content: Text('Thêm thành công!'),
        duration: Duration(seconds: 2), // Thời gian hiển thị
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            allThongTinItemNhap.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DanhSachItemsDaChonScreen(
                      selectedItems: allThongTinItemNhap,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 30) * 6 / 10,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: blueColor,
                      side: BorderSide(
                          color: isButtonEnabled ? blueColor : Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: isButtonEnabled
                        ? () {
                            setState(() {
                              allThongTinItemNhap.add(thongTinItemNhap);
                              thongTinItemNhap = {
                                "macode": "",
                                "tensanpham": "",
                                "location": "",
                                "exp": "",
                                "soluong": 0
                              };
                              _checkFields();
                              _showSuccessSnackbar(context);
                              print(allThongTinItemNhap);
                            });
                          }
                        : null,
                    child: const Text(
                      'Thêm',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 30) * 4 / 10,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: blueColor,
                      side: BorderSide(
                          color: isButtonEnabled ? blueColor : Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: allThongTinItemNhap.isNotEmpty ? () {} : null,
                    child: allThongTinItemNhap.isEmpty
                        ? const Text(
                            'Thanh toán',
                            style: TextStyle(fontSize: 18),
                          )
                        : Text(
                            'Thanh toán (${allThongTinItemNhap.length})',
                            style: const TextStyle(fontSize: 18),
                          ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
