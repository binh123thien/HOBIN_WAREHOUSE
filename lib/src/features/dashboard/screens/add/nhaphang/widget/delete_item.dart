import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/danhsach_items_dachon.dart';

import '../../../../../../constants/icon.dart';
import '../../widget/card_add_widget.dart';

class DeleteItemsScreen extends StatefulWidget {
  final Map<String, dynamic> thongTinItemNhapHienTai;
  const DeleteItemsScreen({super.key, required this.thongTinItemNhapHienTai});

  @override
  State<DeleteItemsScreen> createState() => _DeleteItemsScreenState();
}

class _DeleteItemsScreenState extends State<DeleteItemsScreen> {
  final List<Map<String, dynamic>> list = [];
  @override
  void initState() {
    list.add(widget.thongTinItemNhapHienTai);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DanhSachItemsDaChonScreen(
            blockOnPress: true,
            selectedItems: list,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Tùy chọn",
              style: TextStyle(fontSize: 17),
            ),
          ),
          CardAdd(
            icon: deleteIcon,
            title: "Xóa",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
