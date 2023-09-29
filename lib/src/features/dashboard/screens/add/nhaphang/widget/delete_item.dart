import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/danhsach_items_dachon.dart';

import '../../../../../../common_widgets/snackbar/snackbar.dart';
import '../../../../../../constants/icon.dart';
import '../../widget/card_add_widget.dart';

class DeleteItemsScreen extends StatefulWidget {
  final Map<String, dynamic> thongTinItemNhapHienTai;
  final Function onDelete;
  const DeleteItemsScreen({
    super.key,
    required this.thongTinItemNhapHienTai,
    required this.onDelete,
  });

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
    return Container(
      color: whiteColor,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DanhSachItemsDaChonScreen(
            blockOnPress: true,
            selectedItems: list,
            reLoad: () {},
          ),
          Container(
            height: 10,
            color: greyColor,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text(
              "Tùy chọn",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          CardAdd(
            icon: deleteIcon,
            title: "Xóa",
            onTap: () {
              widget.onDelete();
              Navigator.of(context).pop();
              SnackBarWidget.showSnackBar(
                  context, "Xóa thành công", successColor);
            },
          ),
        ],
      ),
    );
  }
}
