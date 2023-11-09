import 'package:flutter/material.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../card/card_doanhthucacngaytruoc.dart';
import '../card/card_doanhthuhientai.dart';
import '../chitiet_doanhthu_screen.dart';

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
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage(nodataIcon),
            height: size.width * 0.7,
            width: size.width * 0.7,
          ),
          Text(
            "Chưa có giao dịch",
            style: TextStyle(fontSize: Font.sizes(context)[2]),
          ),
        ],
      ));
    }
    return Column(
      children: [
        CardDoanThuHienTai(
          phanloai: "Thang",
          ngay: doanhthutheothang[0]["datetime"],
          tongdoanhthu: doanhthutheothang[0]["doanhthu"],
          thanhcong: doanhthutheothang[0]["thanhcong"],
          title: 'Tháng này',
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
          height: size.height * 0.61,
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
                              builder: (context) => ChiTietDoanhThuScreen(
                                    ngay: ngay,
                                    tongdoanhthu: tongdoanhthu,
                                    thanhcong: thanhcong,
                                    dangcho: dangcho,
                                    huy: huy,
                                    loai: 'Thang',
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
