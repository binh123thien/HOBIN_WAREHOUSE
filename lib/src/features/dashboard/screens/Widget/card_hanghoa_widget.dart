import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../utils/utils.dart';
import '../goods/phanphoihanghoa/phanphoihanghoa.dart';

class CardHangHoa extends StatelessWidget {
  const CardHangHoa({
    super.key,
    required this.hangHoaChoosed,
    required this.tensanpham,
    required this.giaban,
    required this.tonkho,
    required this.daban,
    required this.onTapChiTietHangHoa,
    required this.donvi,
    required this.hinhanh,
    required this.phanBietSiLe,
  });
  final dynamic hangHoaChoosed;
  final bool phanBietSiLe;
  final String tensanpham;
  final num giaban;
  final String tonkho;
  final String daban;
  final String donvi;
  final String hinhanh;
  final VoidCallback onTapChiTietHangHoa;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapChiTietHangHoa,
      child: Card(
        color: whiteColor,
        elevation: 1,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
                    child: SizedBox(
                      height: 45,
                      child: hinhanh.isEmpty
                          ? const Icon(
                              Icons.inventory_2,
                              size: 30,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: hinhanh.toString(),
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tensanpham,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Tồn kho:$tonkho $donvi",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w100),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(giaban),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Đã bán:$daban $donvi",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    )),
                //nút share chuyển sang trang phân phối hàng hóa
                Container(
                  child: phanBietSiLe
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhanPhoiHangHoaScreen(
                                          hanghoaSi: hangHoaChoosed,
                                        )),
                              );
                            },
                            icon: const Icon(
                              Icons.share_outlined,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
