import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';

class XuatThongTinItemXuatHangScreen extends StatefulWidget {
  final bool blockSoLuong;
  final Map<String, dynamic> thongTinItemXuat;
  final VoidCallback chonSoluong;
  final VoidCallback thayDoiGia;
  final VoidCallback checkFields;
  final VoidCallback changeStateBlockSoluong;
  const XuatThongTinItemXuatHangScreen({
    super.key,
    required this.thongTinItemXuat,
    required this.chonSoluong,
    required this.checkFields,
    required this.blockSoLuong,
    required this.changeStateBlockSoluong,
    required this.thayDoiGia,
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
    {"icon": giaIcon, "title": "Giá xuất hàng"},
    {"icon": quantityIcon, "title": "Chọn số lượng"},
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final docs = items[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
          child: InkWell(
            onTap: index == 1 && widget.blockSoLuong ||
                    index == 2 && widget.blockSoLuong
                ? null
                : () {
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
                            widget.thongTinItemXuat["gia"] = value["giaban"];
                            widget.thongTinItemXuat["tonkho"] = value["tonkho"];
                            widget.thongTinItemXuat["soluong"] = 0;
                            widget.checkFields();
                            widget.changeStateBlockSoluong();
                          });
                        }
                      });
                    }
                    if (index == 1) {
                      widget.thayDoiGia();
                    }
                    if (index == 2 && !widget.blockSoLuong) {
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
                      width: size.width * 0.06,
                      height: size.width * 0.06,
                      child: Image(image: AssetImage(docs["icon"]!)),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: index == 0 &&
                              widget.thongTinItemXuat["tensanpham"].isNotEmpty
                          ? Text(
                              widget.thongTinItemXuat["tensanpham"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
                            )
                          : index == 1 && widget.thongTinItemXuat["gia"] != 0
                              ? Text(
                                  formatCurrency(
                                      widget.thongTinItemXuat["gia"]),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[1]))
                              : index == 2 &&
                                      widget.thongTinItemXuat["soluong"] != 0
                                  ? Text(
                                      widget.thongTinItemXuat["soluong"]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[1]))
                                  : Text(docs["title"]!,
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[1])),
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
