import 'package:flutter/material.dart';

class CardLichSuWidget extends StatelessWidget {
  const CardLichSuWidget({
    Key? key,
    required this.image,
    required this.phanloai,
    required this.tenkhach,
    required this.madonhang,
    required this.trangthai,
    required this.ngaygio,
    required this.tongtien,
    required this.colorTongtien,
  }) : super(key: key);

  final String image;
  final String phanloai;
  final String tenkhach;
  final String madonhang;
  final String trangthai;
  final String ngaygio;
  final String tongtien;
  final Color colorTongtien;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: SizedBox(
                height: size.width * 80 / 1080,
                width: size.width * 80 / 1080,
                child: Image(image: AssetImage(image)),
              )),
          Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(phanloai, style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      Text(tenkhach,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(width: 5),
                      Text(madonhang,
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  Text("Trạng thái: $trangthai",
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              )),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ngaygio, style: Theme.of(context).textTheme.titleSmall),
                  Text(tongtien,
                      style: TextStyle(fontSize: 20, color: colorTongtien)),
                ],
              ))
        ],
      ),
    );
  }
}
