import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../controllers/statistics/doanhthu_controller.dart';
import '../card_chitietdoanhthu.dart';
import '../chitiet_doanhthu_screen.dart';

class ChiTietDoanhThuTheoThangScreen extends StatefulWidget {
  final String ngay;
  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;
  const ChiTietDoanhThuTheoThangScreen({
    super.key,
    required this.ngay,
    required this.tongdoanhthu,
    required this.thanhcong,
    required this.dangcho,
    required this.huy,
  });

  @override
  State<ChiTietDoanhThuTheoThangScreen> createState() =>
      _ChiTietDoanhThuTheoThangScreenState();
}

class _ChiTietDoanhThuTheoThangScreenState
    extends State<ChiTietDoanhThuTheoThangScreen> {
  final controllerDoanhThu = DoanhThuController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.ngay,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: whiteColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Column(
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
              StreamBuilder<List<DocumentSnapshot>>(
                stream: controllerDoanhThu.queryDocsByMonth(widget.ngay),
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                  width: size.width - 35,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          backGround600Color.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(ngay,
                                            style:
                                                const TextStyle(fontSize: 15)),
                                        const SizedBox(height: 10),
                                        Text(formatCurrency(tongdoanhthu),
                                            style:
                                                const TextStyle(fontSize: 19)),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Image(
                                                image:
                                                    AssetImage(soluongdonIcon),
                                                height: 15),
                                            Text(
                                              " $thanhcong đơn thành công",
                                              style:
                                                  const TextStyle(fontSize: 15),
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
                    );
                  } else if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error!);
                  }

                  return const CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
