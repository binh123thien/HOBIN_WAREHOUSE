import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import '../../../../../common_widgets/bottom_sheet_pdf.dart';
import '../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../common_widgets/network/network.dart';
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
  String trangthai = "";
  bool isLoading = false;
  bool isHuy = false;
  @override
  void initState() {
    super.initState();
    trangthai = widget.doc["trangthai"];
    controllerHistoryRepo.hoaDonPDFControler.clear();
    controllerHistoryRepo.fetchSanPhamTrongTable(widget.doc);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  size: 30, color: isLoading == false ? darkColor : greyColor),
              onPressed: isLoading == false
                  ? () {
                      Navigator.of(context).pop(isHuy);
                    }
                  : null),
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
                trangthai: trangthai,
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
                    side: BorderSide(
                        color:
                            trangthai == "Hủy" ? backGroundColor : Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: trangthai == "Hủy"
                      ? null
                      : () {
                          NetWork.checkConnection().then((value) async {
                            if (value == "Not Connected") {
                              MyDialog.showAlertDialogOneBtn(
                                  context,
                                  "Không có Internet",
                                  "Vui lòng kết nối internet và thử lại sau");
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              await controllerHistory
                                  .handleHuyDon(
                                      widget.doc["soHD"],
                                      widget.doc["billType"],
                                      widget.doc["tongthanhtoan"],
                                      widget.doc["datetime"],
                                      widget.doc["trangthai"])
                                  .then(
                                (value) {
                                  setState(() {
                                    isLoading = false;
                                    isHuy = true;
                                    trangthai = "Hủy";
                                  });
                                },
                              );
                            }
                          });
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ) // Hiển thị tiến trình loading
                      : const Text(
                          'Hủy đơn',
                          style: TextStyle(fontSize: 19),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
