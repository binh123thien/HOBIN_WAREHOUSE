import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../utils/utils.dart';

class ThongTinHangHoaWidget extends StatelessWidget {
  const ThongTinHangHoaWidget({
    super.key,
    required this.hanghoa,
  });
  final dynamic hanghoa;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: mainColor,
            ),
            height: size.height * 0.28,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Thông tin hàng hóa",
                style: TextStyle(
                    fontSize: Font.sizes(context)[2], color: whiteColor),
              ),
            ),
          ),
          Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                width: size.width - 10,
                height: size.height * 0.228,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: whiteColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Mã SP",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          Text(hanghoa["macode"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Giá nhập",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          Text(formatCurrency(hanghoa["gianhap"]),
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Giá bán",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          Text(formatCurrency(hanghoa["giaban"]),
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phân loại",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          Text(hanghoa["phanloai"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Đơn vị",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          Text(hanghoa["donvi"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Danh mục",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          // if (danhmuc.length == 0)
                          //   Text(danhmuc)
                          // else
                          for (int i = 0; i < hanghoa["danhmuc"].length; i++)
                            Text(hanghoa["danhmuc"][i],
                                style:
                                    TextStyle(fontSize: Font.sizes(context)[1]))
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
