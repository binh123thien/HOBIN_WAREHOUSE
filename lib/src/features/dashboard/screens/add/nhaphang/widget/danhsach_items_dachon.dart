import 'package:flutter/material.dart';
import '../../../../../../common_widgets/dotline/dotline.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Image(image: AssetImage(tongtienxuatkhoIcon)),
                  ),
                  SizedBox(width: 7),
                  Text("Ước tính chi phí",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tổng tiền:", style: TextStyle(fontSize: 17)),
                    Text(formatCurrency(totalPrice),
                        style: const TextStyle(fontSize: 17)),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("Tổng số lượng:", style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Text(totalQuantity.toString(),
                        style: const TextStyle(fontSize: 17)),
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
