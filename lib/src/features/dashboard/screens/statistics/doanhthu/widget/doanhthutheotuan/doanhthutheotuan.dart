import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../card/card_doanhthucacngaytruoc.dart';
import '../card/card_doanhthuhientai.dart';
import '../chitiet_doanhthu_screen.dart';

class DoanhThuTheoTuanWidget extends StatelessWidget {
  const DoanhThuTheoTuanWidget({
    super.key,
    required this.doanhthuTheoTuan,
  });

  final List<dynamic> doanhthuTheoTuan;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (doanhthuTheoTuan.isEmpty) {
      return const Center(child: Text("Chưa có giao dịch"));
    }
    return Column(
      children: [
        CardDoanThuHienTai(
          phanloai: "Tuan",
          ngay: doanhthuTheoTuan[0]["datetime"],
          tongdoanhthu: doanhthuTheoTuan[0]["doanhthu"],
          thanhcong: doanhthuTheoTuan[0]["thanhcong"],
          title:
              'Tuần này ${doanhthuTheoTuan[0]["datetime"].replaceAll(RegExp(r'Tuần \d+'), '')}',
          dangcho: doanhthuTheoTuan[0]["dangcho"],
          huy: doanhthuTheoTuan[0]["huy"],
          week: doanhthuTheoTuan[0]["week"],
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
          child: doanhthuTheoTuan.length > 1
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: doanhthuTheoTuan.length - 1,
                  itemBuilder: (context, index) {
                    String ngay = doanhthuTheoTuan[index + 1]["datetime"];
                    String week = doanhthuTheoTuan[index + 1]["week"];
                    num tongdoanhthu = doanhthuTheoTuan[index + 1]["doanhthu"];
                    int thanhcong = doanhthuTheoTuan[index + 1]["thanhcong"];
                    int dangcho = doanhthuTheoTuan[index + 1]["dangcho"];
                    int huy = doanhthuTheoTuan[index + 1]["huy"];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChiTietDoanhThuScreen(
                                    week: week,
                                    ngay: ngay,
                                    tongdoanhthu: tongdoanhthu,
                                    thanhcong: thanhcong,
                                    dangcho: dangcho,
                                    huy: huy,
                                    loai: 'Tuan',
                                  )),
                        );
                      },
                      child: CardDoanhThuCacNgayTruoc(
                          ngay: ngay,
                          tongdoanhthu: tongdoanhthu,
                          thanhcong: thanhcong),
                    );
                  },
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
