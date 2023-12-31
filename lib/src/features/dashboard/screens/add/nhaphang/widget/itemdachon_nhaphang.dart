import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';
import 'delete_item.dart';

class ItemDaChonNhapHangWidget extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final bool blockOnPress;
  final Function reLoad;
  const ItemDaChonNhapHangWidget(
      {super.key,
      required this.selectedItems,
      required this.blockOnPress,
      required this.reLoad});

  @override
  State<ItemDaChonNhapHangWidget> createState() =>
      _ItemDaChonNhapHangWidgetState();
}

class _ItemDaChonNhapHangWidgetState extends State<ItemDaChonNhapHangWidget> {
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
        return DeleteItemsScreen(
          thongTinItemNhapHienTai: widget.selectedItems[index],
          onDelete: () {
            widget.selectedItems.removeAt(index);
            widget.reLoad(widget.selectedItems);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 7),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Image(image: AssetImage(tongsoluongxuatkhoIcon)),
              ),
              SizedBox(width: 7),
              Text(
                "Danh sách đã chọn",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
                          style: const TextStyle(fontSize: 17)),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text("${docdata["exp"]} - ${docdata["location"]}",
                                  style: const TextStyle(fontSize: 14))
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${formatCurrency(docdata['gia'])} x ${docdata["soluong"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  formatCurrency(
                                      docdata['gia'] * docdata["soluong"]),
                                  style: const TextStyle(fontSize: 14),
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
