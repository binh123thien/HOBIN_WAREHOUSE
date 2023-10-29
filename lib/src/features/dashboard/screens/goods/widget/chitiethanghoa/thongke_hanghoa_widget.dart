import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class ThongKeHangHoaWidget extends StatelessWidget {
  const ThongKeHangHoaWidget({
    super.key,
    required this.hanghoa,
  });
  final dynamic hanghoa;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: mainColor,
            ),
            height: size.height * 0.14,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Thống kê",
                style: TextStyle(
                    fontSize: Font.sizes(context)[1], color: whiteColor),
              ),
            ),
          ),
          Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                width: size.width - 10,
                height: size.height * 0.095,
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
                          Text("Tồn kho",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("${hanghoa["tonkho"]} ${hanghoa["donvi"]}",
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Đã bán",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("${hanghoa["daban"]} ${hanghoa["donvi"]}",
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
