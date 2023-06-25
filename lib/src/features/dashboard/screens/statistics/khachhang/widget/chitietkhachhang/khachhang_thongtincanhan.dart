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
        const SizedBox(height: 18),
        Card(
          color: whiteColor,
          elevation: 2,
          child: SizedBox(
            width: size.width - 30,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin cá nhân",
                    style: TextStyle(fontSize: 17),
                  ),
                  const Divider(),
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Mã KH", style: TextStyle(fontSize: 17)),
                          Text(khachhang["maKH"],
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Số điện thoại",
                              style: TextStyle(fontSize: 17)),
                          Text(khachhang["sdt"],
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Địa chỉ", style: TextStyle(fontSize: 17)),
                          Text(khachhang["diachi"],
                              style: const TextStyle(fontSize: 17)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
