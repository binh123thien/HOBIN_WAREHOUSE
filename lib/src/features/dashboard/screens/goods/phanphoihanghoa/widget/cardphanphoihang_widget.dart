import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardPhanPhoiHang extends StatelessWidget {
  const CardPhanPhoiHang({
    super.key,
    required this.donViProduct,
    required this.imageProduct,
    required this.updatehanghoa,
    required this.slchuyendoi,
  });
  final int slchuyendoi;
  final String imageProduct;
  final String donViProduct;
  final dynamic updatehanghoa;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      Text(' $donViProduct  ',
                          style: const TextStyle(fontSize: 15)),
                      //nếu slchuyendoi có giá trị thì hiển thị UI
                      (slchuyendoi != 0)
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.arrow_upward_outlined,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Text(
                                  '$slchuyendoi',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ],
                            )
                          : const Text('')
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
