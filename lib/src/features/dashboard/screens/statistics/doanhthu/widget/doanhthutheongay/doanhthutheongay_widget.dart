import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';
import '../chitiet_doanhthu_screen.dart';
import '../doanhthu_tieude_widget.dart';

class DoanhThuTheoNgayWidget extends StatelessWidget {
  const DoanhThuTheoNgayWidget({
    super.key,
    required this.doanhthu,
  });

  final RxList<Map<String, dynamic>> doanhthu;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        DoanhThuTieuDe(
          ngay: doanhthu[0].keys.first,
          tongdoanhthu: doanhthu[0].values.first,
          thanhcong: doanhthu[0]["thanhcong"],
          title: 'Hôm nay',
          dangcho: doanhthu[0]["dangcho"],
          huy: doanhthu[0]["huy"],
        ),
        const SizedBox(height: 5),
        const Divider(
          height: 1,
          color: darkColor,
        ),
        SizedBox(
          height: size.height - 335,
          width: size.width - 30,
          // color: Colors.amber,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: doanhthu.length - 1,
            itemBuilder: (context, index) {
              String ngay = doanhthu[index + 1].keys.first;
              num tongdoanhthu = doanhthu[index + 1].values.first;
              int thanhcong = doanhthu[index + 1]["thanhcong"];
              int dangcho = doanhthu[index + 1]["dangcho"];
              int huy = doanhthu[index + 1]["huy"];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChiTietDoanhThuScreen(
                              ngay: ngay,
                              tongdoanhthu: tongdoanhthu,
                              thanhcong: thanhcong,
                              dangcho: dangcho,
                              huy: huy,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                      width: size.width - 35,
                      height: 100,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: backGround600Color.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ngay, style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 10),
                            Text(formatCurrency(tongdoanhthu),
                                style: const TextStyle(fontSize: 19)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Image(
                                    image: AssetImage(soluongdonIcon),
                                    height: 15),
                                Text(
                                  " $thanhcong đơn thành công",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
