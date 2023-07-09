import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';
import '../card/card_doanhthuhientai.dart';
import 'chitietdoanhthu_theothang.dart';

class DoanhThuTheoThangWidget extends StatelessWidget {
  const DoanhThuTheoThangWidget({
    super.key,
    required this.doanhthutheothang,
  });

  final List<dynamic> doanhthutheothang;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (doanhthutheothang.isEmpty) {
      return const Center(child: Text("Chưa có giao dịch"));
    }
    return Column(
      children: [
        CardDoanThuHienTai(
          phanloai: "thang",
          ngay: doanhthutheothang[0]["datetime"],
          tongdoanhthu: doanhthutheothang[0]["doanhthu"],
          thanhcong: doanhthutheothang[0]["thanhcong"],
          title: 'Thâng này',
          dangcho: doanhthutheothang[0]["dangcho"],
          huy: doanhthutheothang[0]["huy"],
          week: '',
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
          child: doanhthutheothang.length > 1
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: doanhthutheothang.length - 1,
                  itemBuilder: (context, index) {
                    String ngay = doanhthutheothang[index + 1]["datetime"];
                    num tongdoanhthu = doanhthutheothang[index + 1]["doanhthu"];
                    int thanhcong = doanhthutheothang[index + 1]["thanhcong"];
                    int dangcho = doanhthutheothang[index + 1]["dangcho"];
                    int huy = doanhthutheothang[index + 1]["huy"];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChiTietDoanhThuTheoThangScreen(
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
                                  Text(ngay,
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(height: 10),
                                  Text(formatCurrency(tongdoanhthu),
                                      style: const TextStyle(fontSize: 19)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Image(
                                          image:
                                              AssetImage(doanhthuThanhCongIcon),
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
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
