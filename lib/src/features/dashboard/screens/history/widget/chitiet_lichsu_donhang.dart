import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/bottom_sheet_pdf.dart';
import '../../../../../common_widgets/printting.dart';
import '../../../../../constants/color.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../../add/widget/chitietdonhang/table_chitietdonhang_widget.dart';
import '../../add/widget/chitietdonhang/total_price_chitietdonhang_widget.dart';
import '../../add/widget/chitietdonhang_moi/tieude_chitietdonhang.dart';

class ChiTietLichSuDonHang extends StatefulWidget {
  final dynamic doc;
  const ChiTietLichSuDonHang({super.key, required this.doc});

  @override
  State<ChiTietLichSuDonHang> createState() => _ChiTietLichSuDonHangState();
}

class _ChiTietLichSuDonHangState extends State<ChiTietLichSuDonHang> {
  final controllerHistoryRepo = Get.put(HistoryRepository());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Chi tiết đơn hàng",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    builder: (context) => BottomSheetPDF(
                          textOneofTwo: 'in hóa đơn',
                          onTapGallery: () {
                            //truyền widget.doc để có thể hiển thị list chi tiết thanh toán
                            printPDF(widget.doc, context);
                          },
                          onTapCamera: () {
                            sharePDF(widget.doc, context);
                          },
                        ));
              },
              icon: const Icon(
                Icons.print,
                size: 35,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TieuDeChiTietDonHang(
              no: widget.doc["no"],
              bHcode: widget.doc["soHD"],
              date: widget.doc["ngaytao"],
              tongtien: widget.doc["tongthanhtoan"],
              paymentSelected: widget.doc["payment"],
              khachhang: widget.doc["khachhang"],
              billType: widget.doc["billType"],
            ),
            const Divider(),
            const Text("Chi tiết hóa đơn",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            SizedBox(
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: controllerHistoryRepo.getAllSanPhamTrongHoaDon(
                        widget.doc["soHD"],
                        widget.doc["billType"] == "BanHang"
                            ? "BanHang"
                            : "NhapHang"),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: ((BuildContext context, int index) {
                              List<dynamic> document = snapshot.data!.docs;
                              return TableChiTietDonHang(
                                filteredList: document,
                                phanbietNhapXuat:
                                    widget.doc['billType'] == "BanHang" ? 0 : 1,
                              );
                            }));
                      }
                    })),
            const Divider(),
            TotalPriceChiTietDonHangWidget(
              billType: widget.doc["billType"],
              sumItem: widget.doc["tongsl"],
              sumPrice: widget.doc["tongtien"],
              disCount: widget.doc["giamgia"],
              tienno: widget.doc["no"],
            ),
          ],
        ),
      ),
    );
  }
}
