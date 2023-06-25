import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';

class CardPhanPhoiHang extends StatelessWidget {
  const CardPhanPhoiHang({
    super.key,
    required this.donViProduct,
    required this.imageProduct,
    required this.updatehanghoa,
  });

  final String imageProduct;
  final String donViProduct;
  final dynamic updatehanghoa;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 30, 0, 20),
      child: Card(
        color: backGroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
          child: Row(
            children: [
              updatehanghoa['photoGood'].isEmpty
                  ? Image(
                      image: AssetImage(imageProduct),
                      height: 35,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: updatehanghoa['photoGood'].toString(),
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
              const Padding(padding: EdgeInsets.only(left: 7)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          '${donViProduct.substring(0, 1).toUpperCase()}${donViProduct.substring(1)} '),
                      Text(updatehanghoa['tensanpham'])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Tồn kho: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(updatehanghoa['tonkho'].toString(),
                          style: const TextStyle(fontSize: 15)),
                      Text(' $donViProduct',
                          style: const TextStyle(fontSize: 15)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
