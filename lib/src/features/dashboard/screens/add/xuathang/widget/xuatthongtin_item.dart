import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';

class XuatThongTinItemXuatHangScreen extends StatefulWidget {
  final Map<String, dynamic> thongTinItemXuat;
  final VoidCallback chonSoluong;
  const XuatThongTinItemXuatHangScreen({
    super.key,
    required this.thongTinItemXuat,
    required this.chonSoluong,
  });

  @override
  State<XuatThongTinItemXuatHangScreen> createState() =>
      _XuatThongTinItemXuatHangScreenState();
}

class _XuatThongTinItemXuatHangScreenState
    extends State<XuatThongTinItemXuatHangScreen> {
  final int phanBietXuat = 0;
  List<Map<String, String>> items = [
    {"icon": goodsIcon, "title": "Chọn hàng hóa"},
    {"icon": quantityIcon, "title": "Chọn số lượng"},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
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
                      builder: (context) => ChooseGoodsScreen(
                            phanBietNhapXuat: phanBietXuat,
                          )),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      widget.thongTinItemXuat["tensanpham"] =
                          value["tensanpham"];
                      widget.thongTinItemXuat["macode"] = value["macode"];
                      widget.thongTinItemXuat["gia"] = value["gianhap"];
                      // widget.checkFields();
                    });
                  }
                });
              }
              if (index == 1) {
                widget.chonSoluong();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                              widget.thongTinItemXuat["tensanpham"].isNotEmpty
                          ? Text(
                              widget.thongTinItemXuat["tensanpham"],
                              style: const TextStyle(fontSize: 17),
                            )
                          : index == 1 &&
                                  widget.thongTinItemXuat["soluong"] != 0
                              ? Text(
                                  widget.thongTinItemXuat["soluong"].toString(),
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
