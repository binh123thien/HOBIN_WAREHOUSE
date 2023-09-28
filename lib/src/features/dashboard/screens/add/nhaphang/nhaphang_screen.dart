import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_location.dart';
import 'package:intl/intl.dart';

import 'widget/chonsoluong_widget.dart';

class NhapHangScreen extends StatefulWidget {
  const NhapHangScreen({super.key});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
  List<Map<String, String>> items = [
    {"icon": goodsIcon, "title": "Chọn hàng hóa"},
    {"icon": locationIcon, "title": "Chọn vị trí"},
    {"icon": calendarIcon, "title": "Chọn ngày hết hạn"},
    {"icon": quantityIcon, "title": "Chọn số lượng"},
  ];
  List<Map<String, dynamic>> allThongTinItemNhap = [];
  Map<String, dynamic> thongTinItemNhap = {
    "macode": "",
    "hanghoa": "",
    "location": "",
    "exp": "",
    "soluong": 0
  };
  bool isButtonEnabled = false;
  // Hàm kiểm tra xem tất cả các trường đã có dữ liệu hay chưa
  void _checkFields() {
    if (thongTinItemNhap["hanghoa"].isNotEmpty &&
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        thongTinItemNhap["exp"] = DateFormat('dd/MM/yyyy').format(picked);
        _checkFields();
      });
    }
  }

  Future<void> _chonSoluong(BuildContext context) async {
    String soluong = await showModalBottomSheet(
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
    );
    if (soluong.isNotEmpty) {
      setState(() {
        thongTinItemNhap["soluong"] = int.tryParse(soluong);
        _checkFields();
      });
    }
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
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              final docs = items[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChooseGoodsScreen()),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            thongTinItemNhap["hanghoa"] = value["tensanpham"];
                            thongTinItemNhap["macode"] = value["macode"];
                            _checkFields();
                          });
                        }
                      });
                    }
                    if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChooseLocationScreen()),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            thongTinItemNhap["location"] = value["id"];
                            _checkFields();
                          });
                        }
                      });
                    }
                    if (index == 2) {
                      _selectDate(context);
                    }
                    if (index == 3) {
                      _chonSoluong(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: Image(image: AssetImage(docs["icon"]!)),
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: index == 0 &&
                                    thongTinItemNhap["hanghoa"].isNotEmpty
                                ? Text(
                                    thongTinItemNhap["hanghoa"],
                                    style: const TextStyle(fontSize: 17),
                                  )
                                : index == 1 &&
                                        thongTinItemNhap["location"].isNotEmpty
                                    ? Text(
                                        thongTinItemNhap["location"],
                                        style: const TextStyle(fontSize: 17),
                                      )
                                    : index == 2 &&
                                            thongTinItemNhap["exp"].isNotEmpty
                                        ? Text(
                                            thongTinItemNhap["exp"],
                                            style:
                                                const TextStyle(fontSize: 17),
                                          )
                                        : index == 3 &&
                                                thongTinItemNhap["soluong"] != 0
                                            ? Text(
                                                thongTinItemNhap["soluong"]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )
                                            : Text(
                                                docs["title"]!,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 30,
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
                              "hanghoa": "",
                              "location": "",
                              "exp": "",
                              "soluong": 0
                            };
                            _checkFields();
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
            }),
          ],
        ),
      ),
    );
  }
}
