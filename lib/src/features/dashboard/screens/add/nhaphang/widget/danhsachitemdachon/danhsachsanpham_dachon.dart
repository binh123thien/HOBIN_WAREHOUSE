import 'package:flutter/material.dart';

import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';

class DanhSachSanPhamDaChonWidget extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const DanhSachSanPhamDaChonWidget({super.key, required this.selectedItems});

  @override
  State<DanhSachSanPhamDaChonWidget> createState() =>
      _DanhSachSanPhamDaChonWidgetState();
}

class _DanhSachSanPhamDaChonWidgetState
    extends State<DanhSachSanPhamDaChonWidget> {
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
                "Danh sách sản phẩm",
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
                ListTile(
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
                index != widget.selectedItems.length - 1
                    ? PhanCachWidget.dotLine(context)
                    : const SizedBox(height: 7)
              ],
            );
          },
        ),
      ],
    );
  }
}
