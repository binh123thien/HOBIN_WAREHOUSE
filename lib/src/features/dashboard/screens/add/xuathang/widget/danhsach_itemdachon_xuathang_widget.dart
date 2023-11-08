import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';
import 'delete_item_xuathang.dart';

class DanhSachItemDaChonXuatHangWidget extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final bool blockOnPress;
  final Function reLoadOnDeleteXuatHang;
  const DanhSachItemDaChonXuatHangWidget(
      {super.key,
      required this.selectedItems,
      required this.blockOnPress,
      required this.reLoadOnDeleteXuatHang});

  @override
  State<DanhSachItemDaChonXuatHangWidget> createState() =>
      _DanhSachItemDaChonXuatHangWidgetState();
}

class _DanhSachItemDaChonXuatHangWidgetState
    extends State<DanhSachItemDaChonXuatHangWidget> {
  void _deleteItem(int index) {
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
        return DeleteItemXuatHangScreen(
          thongTinItemNhapHienTai: widget.selectedItems[index],
          onDelete: () {
            String macode = widget.selectedItems[index]["macode"];
            num soluong = widget.selectedItems[index]["soluong"];
            widget.selectedItems.removeAt(index);
            widget.reLoadOnDeleteXuatHang(
                widget.selectedItems, macode, soluong);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 7),
          child: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: Image(image: AssetImage(tongsoluongxuatkhoIcon)),
              ),
              const SizedBox(width: 7),
              Text(
                "Danh sách đã chọn",
                style: TextStyle(
                    fontSize: Font.sizes(context)[1],
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.selectedItems.length,
          itemBuilder: (context, index) {
            final docdata = widget.selectedItems[index];
            return Column(
              children: [
                InkWell(
                  onLongPress: widget.blockOnPress == false
                      ? () {
                          _deleteItem(index);
                        }
                      : null,
                  child: ListTile(
                      leading: CircleAvatar(
                        // radius: 17,
                        backgroundColor: backGroundColor,
                        foregroundColor: mainColor,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                      title: Text("${docdata['tensanpham']} ",
                          style: TextStyle(fontSize: Font.sizes(context)[1])),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 3),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: docdata["locationAndexp"].length,
                            itemBuilder: (context, index) {
                              final listLocation =
                                  docdata["locationAndexp"][index];
                              return Row(
                                children: [
                                  Text(
                                      "HSD: ${listLocation["exp"]} - ${listLocation["location"]} - SL: ${listLocation["soluong"]} ",
                                      style: TextStyle(
                                          fontSize:
                                              Font.sizes(context)[0] * 0.9))
                                ],
                              );
                            },
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${formatCurrency(docdata['gia'])} x ${docdata["soluong"]}",
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0] * 0.9),
                                ),
                                Text(
                                  formatCurrency(
                                      docdata['gia'] * docdata["soluong"]),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0] * 0.9),
                                )
                              ]),
                        ],
                      )
                      // Các thuộc tính khác của CheckboxListTile
                      // ...
                      ),
                ),
                index != widget.selectedItems.length - 1
                    ? PhanCachWidget.dotLine(context)
                    : const SizedBox()
              ],
            );
          },
        ),
      ],
    );
  }
}
