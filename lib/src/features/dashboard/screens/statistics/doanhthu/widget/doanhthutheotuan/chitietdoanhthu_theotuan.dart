import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../controllers/statistics/doanhthu_controller.dart';
import '../card_chitietdoanhthu.dart';
import '../chitiet_doanhthu_screen.dart';

class ChiTietDoanhThuTheoTuanScreen extends StatefulWidget {
  final String ngay;
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
      required this.huy});

  @override
  State<ChiTietDoanhThuTheoTuanScreen> createState() =>
      _ChiTietDoanhThuTheoTuanScreenState();
}

class _ChiTietDoanhThuTheoTuanScreenState
    extends State<ChiTietDoanhThuTheoTuanScreen> {
  final controllerDoanhThu = DoanhThuController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doanhthu = controllerDoanhThu.doanhThu;
    List<String> dateStrings = widget.ngay.split(' - ');
    DateTime startDate =
        DateFormat('dd/MM/yyyy').parse('${dateStrings.first}/2023');
    DateTime endDate =
        DateFormat('dd/MM/yyyy').parse('${dateStrings.last}/2023');

    List<dynamic> doanhThu7ngayTrongTuan = doanhthu.where((entry) {
      DateTime entryDate = DateFormat('dd/MM/yyyy').parse(entry.keys.first);
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: doanhThu7ngayTrongTuan.length,
                  itemBuilder: (context, index) {
                    String ngay = doanhThu7ngayTrongTuan[index].keys.first;
                    num tongdoanhthu =
                        doanhThu7ngayTrongTuan[index].values.first;
                    int thanhcong = doanhThu7ngayTrongTuan[index]["thanhcong"];
                    int dangcho = doanhThu7ngayTrongTuan[index]["dangcho"];
                    int huy = doanhThu7ngayTrongTuan[index]["huy"];
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
                                  Text(ngay,
                                      style: const TextStyle(fontSize: 15)),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
