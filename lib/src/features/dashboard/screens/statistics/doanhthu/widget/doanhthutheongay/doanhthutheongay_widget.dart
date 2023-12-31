import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../card/card_doanhthucacngaytruoc.dart';
import '../chitiet_doanhthu_screen.dart';
import '../card/card_doanhthuhientai.dart';

class DoanhThuTheoNgayWidget extends StatelessWidget {
  const DoanhThuTheoNgayWidget({
    super.key,
    required this.doanhthu,
  });

  final List<dynamic> doanhthu;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (doanhthu.isEmpty) {
      return const Center(child: Text("Chưa có giao dịch"));
    }
    return Column(
      children: [
        CardDoanThuHienTai(
          phanloai: "Ngay",
          ngay: doanhthu[0]["datetime"],
          tongdoanhthu: doanhthu[0]["doanhthu"],
          thanhcong: doanhthu[0]["thanhcong"],
          title: 'Hôm nay',
          dangcho: doanhthu[0]["dangcho"],
          huy: doanhthu[0]["huy"],
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
          child: doanhthu.length > 1
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: doanhthu.length - 1,
                  itemBuilder: (context, index) {
                    String ngay = doanhthu[index + 1]["datetime"];
                    num tongdoanhthu = doanhthu[index + 1]["doanhthu"];
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
                                    loai: 'Ngay',
                                    week: '',
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
