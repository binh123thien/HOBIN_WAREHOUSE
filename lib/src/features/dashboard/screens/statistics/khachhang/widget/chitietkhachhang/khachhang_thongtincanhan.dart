import 'package:flutter/material.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';

class ThongTinCaNhan extends StatelessWidget {
  const ThongTinCaNhan({
    super.key,
    this.khachhang,
  });

  final dynamic khachhang;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          khachhang["tenkhachhang"].toString(),
          style: TextStyle(fontSize: Font.sizes(context)[4]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: mainColor,
                ),
                height: size.height * 0.15,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
                  child: Text(
                    "Thông tin cá nhân",
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
                  width: size.width,
                  height: size.height * 0.11,
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
                            Text("Mã KH",
                                style: TextStyle(
                                    fontSize: Font.sizes(context)[1])),
                            Text(khachhang["maKH"],
                                style:
                                    TextStyle(fontSize: Font.sizes(context)[1]))
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Số điện thoại",
                                style: TextStyle(
                                    fontSize: Font.sizes(context)[1])),
                            Text(khachhang["sdt"],
                                style:
                                    TextStyle(fontSize: Font.sizes(context)[1]))
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Địa chỉ",
                                style: TextStyle(
                                    fontSize: Font.sizes(context)[1])),
                            Text(khachhang["diachi"],
                                style:
                                    TextStyle(fontSize: Font.sizes(context)[1]))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
