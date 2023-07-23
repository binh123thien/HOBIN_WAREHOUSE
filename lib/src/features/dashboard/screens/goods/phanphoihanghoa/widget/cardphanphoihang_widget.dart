import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPhanPhoiHang extends StatelessWidget {
  const CardPhanPhoiHang({
    super.key,
    required this.donViProduct,
    required this.imageProduct,
    required this.updatehanghoa,
    required this.slchuyendoi,
    required this.phanBietSiLe,
    required this.soluong,
  });
  //set màu cho tăng giảm card trang done
  final RxInt soluong;
  final bool phanBietSiLe;
  final int slchuyendoi;
  final String imageProduct;
  final String donViProduct;
  final dynamic updatehanghoa;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Obx(
        () {
          return Card(
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
                      Text(
                        updatehanghoa['tensanpham'],
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Tồn kho: ',
                            style: TextStyle(fontSize: 15),
                          ),
                          // lấy soluong cho trang done
                          (soluong != 0)
                              ? Text(soluong.toString(),
                                  style: const TextStyle(fontSize: 15))
                              : Text(updatehanghoa['tonkho'].toString(),
                                  style: const TextStyle(fontSize: 15)),
                          Text(' $donViProduct  ',
                              style: const TextStyle(fontSize: 15)),
                          //lấy slchuyendoi cho trang done
                          (slchuyendoi != 0)
                              ? Row(
                                  children: [
                                    phanBietSiLe
                                        ? const Icon(
                                            Icons.south_outlined,
                                            color: Colors.red,
                                            size: 14,
                                          )
                                        : const Icon(
                                            Icons.arrow_upward_outlined,
                                            color: Colors.green,
                                            size: 14,
                                          ),
                                    phanBietSiLe
                                        ? Text(
                                            '$slchuyendoi',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.red),
                                          )
                                        : Text(
                                            '$slchuyendoi',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
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
          );
        },
      ),
    );
  }
}
