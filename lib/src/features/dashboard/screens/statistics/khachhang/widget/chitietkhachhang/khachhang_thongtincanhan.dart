import 'package:flutter/material.dart';

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
          style: const TextStyle(fontSize: 22),
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
                height: 130,
                width: size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(12, 7, 12, 5),
                  child: Text(
                    "Thông tin cá nhân",
                    style: TextStyle(fontSize: 17, color: whiteColor),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 1,
                right: 1,
                child: Container(
                  width: size.width - 10,
                  height: 95,
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
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(khachhang["maKH"],
                                style: Theme.of(context).textTheme.titleLarge)
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Số điện thoại",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(khachhang["sdt"],
                                style: Theme.of(context).textTheme.titleLarge)
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Địa chỉ",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(khachhang["diachi"],
                                style: Theme.of(context).textTheme.titleLarge)
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
