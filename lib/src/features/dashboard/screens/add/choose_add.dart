import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

import '../goods/widget/them_hang_hoa.dart';
import '../statistics/khachhang/widget/them_khachhang.dart';
import 'choose_goods.dart';
import 'widget/card_add_widget.dart';

class ChooseAddScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tạo",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
          const SizedBox(height: 20),
          CardAdd(
            icon: adddonhangIcon,
            title: "Thêm đơn hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseGoodsScreen(
                          phanbietNhapXuat: 0,
                          controllers: [],
                        )),
              ).then((_) {
                Navigator.pop(context); // Tắt showModalBottomSheet
              });
            },
          ),
          CardAdd(
            icon: importIcon,
            title: "Nhập hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseGoodsScreen(
                          phanbietNhapXuat: 1,
                          controllers: [],
                        )),
              ).then((_) {
                Navigator.pop(context); // Tắt showModalBottomSheet
              });
            },
          ),
          CardAdd(
            icon: addhanghoaIcon,
            title: "Thêm hàng hóa",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThemGoodsScreen()),
              ).then((_) {
                Navigator.pop(context); // Tắt showModalBottomSheet
              });
            },
          ),
          CardAdd(
            icon: addkhachhangIcon,
            title: "Thêm khách hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThemKhachHangScreen()),
              ).then((_) {
                Navigator.pop(context); // Tắt showModalBottomSheet
              });
            },
          ),
        ]),
      ),
    );
  }
}
