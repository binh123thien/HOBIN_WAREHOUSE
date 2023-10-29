import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../choose_location.dart';

class NhapThongTinItemScreen extends StatefulWidget {
  final Map<String, dynamic> thongTinItemNhap;
  final VoidCallback checkFields;
  final VoidCallback thayDoiGia;
  final VoidCallback selectDate;
  final VoidCallback chonSoluong;
  const NhapThongTinItemScreen(
      {super.key,
      required this.thongTinItemNhap,
      required this.checkFields,
      required this.selectDate,
      required this.chonSoluong,
      required this.thayDoiGia});

  @override
  State<NhapThongTinItemScreen> createState() => _NhapThongTinItemScreenState();
}

class _NhapThongTinItemScreenState extends State<NhapThongTinItemScreen> {
  final int phanBietNhap = 1;
  List<Map<String, String>> items = [
    {"icon": goodsIcon, "title": "Chọn hàng hóa"},
    {"icon": giaIcon, "title": "Giá nhập hàng"},
    {"icon": locationIcon, "title": "Chọn vị trí"},
    {"icon": calendarIcon, "title": "Chọn ngày hết hạn"},
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
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseGoodsScreen(
                            phanBietNhapXuat: phanBietNhap,
                          )),
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
                widget.thayDoiGia();
              }
              if (index == 2) {
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
              if (index == 3) {
                widget.selectDate();
              }
              if (index == 4) {
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
                              widget.thongTinItemNhap["tensanpham"].isNotEmpty
                          ? Text(
                              widget.thongTinItemNhap["tensanpham"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
                            )
                          : index == 1 && widget.thongTinItemNhap["gia"] != 0
                              ? Text(
                                  formatCurrency(
                                      widget.thongTinItemNhap["gia"]),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[1]),
                                )
                              : index == 2 &&
                                      widget.thongTinItemNhap["location"]
                                          .isNotEmpty
                                  ? Text(
                                      widget.thongTinItemNhap["location"],
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[1]),
                                    )
                                  : index == 3 &&
                                          widget.thongTinItemNhap["exp"]
                                              .isNotEmpty
                                      ? Text(
                                          widget.thongTinItemNhap["exp"],
                                          style: TextStyle(
                                              fontSize: Font.sizes(context)[1]),
                                        )
                                      : index == 4 &&
                                              widget.thongTinItemNhap[
                                                      "soluong"] !=
                                                  0
                                          ? Text(
                                              widget.thongTinItemNhap["soluong"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      Font.sizes(context)[1]),
                                            )
                                          : Text(
                                              docs["title"]!,
                                              style:
                                                  const TextStyle(fontSize: 17),
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
