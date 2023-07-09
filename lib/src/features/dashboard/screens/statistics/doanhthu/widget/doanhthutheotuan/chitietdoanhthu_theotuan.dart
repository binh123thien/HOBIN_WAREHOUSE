import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../controllers/statistics/doanhthu_controller.dart';
import '../card/card_doanhthucacngaytruoc.dart';
import '../card/card_chitietdoanhthu.dart';
import '../chitiet_doanhthu_screen.dart';

class ChiTietDoanhThuTheoTuanScreen extends StatefulWidget {
  final String ngay;
  final String week;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;
  const ChiTietDoanhThuTheoTuanScreen(
      {super.key,
      required this.ngay,
      required this.tongdoanhthu,
      required this.thanhcong,
      required this.dangcho,
      required this.huy,
      required this.week});

  @override
  State<ChiTietDoanhThuTheoTuanScreen> createState() =>
      _ChiTietDoanhThuTheoTuanScreenState();
}

class _ChiTietDoanhThuTheoTuanScreenState
    extends State<ChiTietDoanhThuTheoTuanScreen> {
  final controllerDoanhThu = DoanhThuController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: whiteColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.ngay,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: whiteColor)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Stack(
            children: [
              Container(
                height: 100,
                color: mainColor,
              ),
              Column(
                children: [
                  CardChiTietDoanhThuWidget(
                    tongdoanhthu: widget.tongdoanhthu,
                    thanhcong: widget.thanhcong,
                    dangcho: widget.dangcho,
                    huy: widget.huy,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text("Chi tiết hàng ngày"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamChiTietDoanhThu(
                      controllerDoanhThu: controllerDoanhThu, widget: widget)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamChiTietDoanhThu extends StatelessWidget {
  const StreamChiTietDoanhThu({
    super.key,
    required this.controllerDoanhThu,
    required this.widget,
  });

  final DoanhThuController controllerDoanhThu;
  final ChiTietDoanhThuTheoTuanScreen widget;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: controllerDoanhThu.filterDocumentsByDate(widget.week),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data!;
          return SizedBox(
            height: size.height - 335,
            width: size.width - 30,
            // color: Colors.amber,
            child: ListView.builder(
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
