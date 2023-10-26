import 'package:flutter/material.dart';
import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';
import 'itemdachon_nhaphang.dart';

class DanhSachItemsDaChonScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final bool blockOnPress;
  final Function reLoad;
  const DanhSachItemsDaChonScreen(
      {super.key,
      required this.selectedItems,
      required this.blockOnPress,
      required this.reLoad});

  @override
  State<DanhSachItemsDaChonScreen> createState() =>
      _DanhSachItemsDaChonScreenState();
}

class _DanhSachItemsDaChonScreenState extends State<DanhSachItemsDaChonScreen> {
  @override
  Widget build(BuildContext context) {
    num totalPrice = widget.selectedItems
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    num totalQuantity = widget.selectedItems
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.045,
                    height: size.width * 0.045,
                    child: const Image(image: AssetImage(tongtienxuatkhoIcon)),
                  ),
                  const SizedBox(width: 7),
                  Text("Ước tính chi phí",
                      style: TextStyle(
                          fontSize: Font.sizes(context)[1],
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text("Tổng tiền:",
                          style: TextStyle(fontSize: Font.sizes(context)[1])),
                    ),
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(totalPrice),
                          style: TextStyle(fontSize: Font.sizes(context)[1]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text("Tổng số lượng:",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1])),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(totalQuantity.toString(),
                            style: TextStyle(fontSize: Font.sizes(context)[1])),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PhanCachWidget.space(),
        ItemDaChonNhapHangWidget(
          selectedItems: widget.selectedItems,
          blockOnPress: widget.blockOnPress,
          reLoad: widget.reLoad,
        ),
      ],
    );
  }
}
