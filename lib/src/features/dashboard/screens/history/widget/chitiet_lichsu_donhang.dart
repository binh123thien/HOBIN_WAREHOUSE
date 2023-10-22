import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import '../../../../../common_widgets/bottom_sheet_pdf.dart';
import '../../../../../common_widgets/printting.dart';
import '../../../../../constants/color.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../../../controllers/history/history_controller.dart';
import '../../add/nhaphang/widget/danhsachitemdachon/danhsach_itemdachon_nhaphang_widget.dart';
import '../../add/thanhtoan/widget/tomtatyeucau.dart';
import '../../add/thanhtoan/widget/tieude_chitietdonhang.dart';
import '../../add/xuathang/widget/danhsach_itemdachon_xuathang_widget.dart';

class ChiTietLichSuDonHang extends StatefulWidget {
  final dynamic doc;
  const ChiTietLichSuDonHang({super.key, required this.doc});

  @override
  State<ChiTietLichSuDonHang> createState() => _ChiTietLichSuDonHangState();
}

class _ChiTietLichSuDonHangState extends State<ChiTietLichSuDonHang> {
  final controllerHistoryRepo = Get.put(HistoryRepository());
  final controllerHistory = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text("Chi tiết đơn hàng",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
          backgroundColor: whiteColor,
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
                trangthai: widget.doc["trangthai"],
              ),
              PhanCachWidget.space(),
              SizedBox(
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: controllerHistoryRepo.getAllSanPhamTrongHoaDon(
                          widget.doc["soHD"],
                          widget.doc["billType"] == "XuatHang" ||
                                  widget.doc["billType"] == "HetHan"
                              ? "XuatHang"
                              : "NhapHang"),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: ((BuildContext context, int index) {
                                List<Map<String, dynamic>> document = [];

                                for (var doc in snapshot.data!.docs) {
                                  document
                                      .add(doc.data() as Map<String, dynamic>);
                                }
                                if (widget.doc["billType"] == "NhapHang" ||
                                    widget.doc["billType"] == "HetHan") {
                                  return DanhSachItemDaChonNhapHangWidget(
                                    selectedItems: document,
                                  );
                                } else {
                                  return DanhSachItemDaChonXuatHangWidget(
                                    selectedItems: document,
                                    blockOnPress: true,
                                    reLoadOnDeleteXuatHang: () {},
                                  );
                                }
                              }));
                        }
                      })),
              PhanCachWidget.space(),
              TomTatYeuCauWidget(
                totalQuantity: widget.doc["tongsl"],
                totalPrice: widget.doc["tongtien"],
                giamgia: widget.doc["giamgia"],
                no: widget.doc["no"],
                tong: widget.doc["tongthanhtoan"],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    handleHuyDon(
                        context,
                        widget.doc["soHD"],
                        widget.doc["billType"],
                        widget.doc["tongthanhtoan"],
                        widget.doc["datetime"],
                        widget.doc["trangthai"]);
                  },
                  child: const Text(
                    'Hủy đơn',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> handleHuyDon(BuildContext context, String soHD, String billType,
      num doanhthu, String datetime, String trangthai) async {
    try {
      //tim document nhap hang hoac xuat hang dua vao billtype de lay doc
      await controllerHistory.findHoaDon(
          soHD, billType, doanhthu, datetime, trangthai);
    } catch (e) {
      // print("Error: $e");
    }
  }
}
