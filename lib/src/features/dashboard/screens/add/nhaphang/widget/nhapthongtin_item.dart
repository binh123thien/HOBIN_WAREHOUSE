import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../choose_location.dart';

class NhapThongTinItemScreen extends StatefulWidget {
  final Map<String, dynamic> thongTinItemNhap;
  final VoidCallback checkFields;
  final VoidCallback selectDate;
  final VoidCallback chonSoluong;
  const NhapThongTinItemScreen(
      {super.key,
      required this.thongTinItemNhap,
      required this.checkFields,
      required this.selectDate,
      required this.chonSoluong});

  @override
  State<NhapThongTinItemScreen> createState() => _NhapThongTinItemScreenState();
}

class _NhapThongTinItemScreenState extends State<NhapThongTinItemScreen> {
  List<Map<String, String>> items = [
    {"icon": goodsIcon, "title": "Chọn hàng hóa"},
    {"icon": locationIcon, "title": "Chọn vị trí"},
    {"icon": calendarIcon, "title": "Chọn ngày hết hạn"},
    {"icon": quantityIcon, "title": "Chọn số lượng"},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                      widget.thongTinItemNhap["tensanpham"] =
                          value["tensanpham"];
                      widget.thongTinItemNhap["macode"] = value["macode"];
                      widget.thongTinItemNhap["gia"] = value["gianhap"];
                      widget.checkFields();
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
                      widget.thongTinItemNhap["location"] = value["id"];
                      widget.checkFields();
                    });
                  }
                });
              }
              if (index == 2) {
                widget.selectDate();
              }
              if (index == 3) {
                widget.chonSoluong();
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
                              widget.thongTinItemNhap["tensanpham"].isNotEmpty
                          ? Text(
                              widget.thongTinItemNhap["tensanpham"],
                              style: const TextStyle(fontSize: 17),
                            )
                          : index == 1 &&
                                  widget.thongTinItemNhap["location"].isNotEmpty
                              ? Text(
                                  widget.thongTinItemNhap["location"],
                                  style: const TextStyle(fontSize: 17),
                                )
                              : index == 2 &&
                                      widget.thongTinItemNhap["exp"].isNotEmpty
                                  ? Text(
                                      widget.thongTinItemNhap["exp"],
                                      style: const TextStyle(fontSize: 17),
                                    )
                                  : index == 3 &&
                                          widget.thongTinItemNhap["soluong"] !=
                                              0
                                      ? Text(
                                          widget.thongTinItemNhap["soluong"]
                                              .toString(),
                                          style: const TextStyle(fontSize: 17),
                                        )
                                      : Text(
                                          docs["title"]!,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
