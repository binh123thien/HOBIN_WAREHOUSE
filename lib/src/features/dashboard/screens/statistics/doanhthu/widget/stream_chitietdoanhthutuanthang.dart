import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../controllers/statistics/doanhthu_controller.dart';
import 'card/card_doanhthucacngaytruoc.dart';
import 'chitiet_doanhthu_screen.dart';

class StreamChiTietDoanhThuTuanThang extends StatelessWidget {
  const StreamChiTietDoanhThuTuanThang({
    super.key,
    required this.controllerDoanhThu,
    required this.widget,
    required this.loai,
  });

  final DoanhThuController controllerDoanhThu;
  final String widget;
  final String loai;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: loai == "Tuan"
          ? controllerDoanhThu.filterDocumentsByDate(widget)
          : controllerDoanhThu.queryDocsByMonth(widget),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data!;
          return SizedBox(
            width: size.width - 30,
            // color: Colors.amber,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                String ngay = documents[index]["datetime"];
                num tongdoanhthu = documents[index]["doanhthu"];
                int thanhcong = documents[index]["thanhcong"];
                int dangcho = documents[index]["dangcho"];
                int huy = documents[index]["huy"];
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
                                week: widget,
                              )),
                    );
                  },
                  child: CardDoanhThuCacNgayTruoc(
                      ngay: ngay,
                      tongdoanhthu: tongdoanhthu,
                      thanhcong: thanhcong),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
