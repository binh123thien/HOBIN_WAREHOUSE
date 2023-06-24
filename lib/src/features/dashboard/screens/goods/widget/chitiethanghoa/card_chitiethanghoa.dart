import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../utils/utils.dart';

class ChiTietHangHoa extends StatelessWidget {
  const ChiTietHangHoa({
    super.key,
    required this.macode,
    required this.gianhap,
    required this.giaban,
    required this.phanloai,
    required this.donvi,
    required this.danhmuc,
  });

  final String macode;
  final num gianhap;
  final num giaban;
  final String phanloai;
  final String donvi;
  final List danhmuc;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backGround600Color,
            ),
            height: 195,
            width: size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Text(
                "Thông tin hàng hóa",
                style: TextStyle(fontSize: 16, color: whiteColor),
              ),
            ),
          ),
          Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                width: size.width - 10,
                height: 165,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(macode,
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Giá nhập",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(formatCurrency(gianhap),
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Giá bán",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(formatCurrency(giaban),
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phân loại",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(phanloai,
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Đơn vị",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(donvi,
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Danh mục",
                              style: Theme.of(context).textTheme.titleLarge),
                          // if (danhmuc.length == 0)
                          //   Text(danhmuc)
                          // else
                          for (int i = 0; i < danhmuc.length; i++)
                            Text(danhmuc[i],
                                style: Theme.of(context).textTheme.titleLarge)
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
