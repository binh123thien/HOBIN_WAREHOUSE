import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/bottom_sheet_pdf.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/common_widgets/printting.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../models/themdonhang_model.dart';
import '../nhaphang/widget/danhsachitemdachon/danhsach_itemdachon_nhaphang_widget.dart';
import 'widget/tieude_chitietdonhang.dart';
import '../xuathang/widget/danhsach_itemdachon_xuathang_widget.dart';
import 'widget/tomtatyeucau.dart';

class ChiTietHoaDonScreen extends StatefulWidget {
  final String phanbietNhapXuat;
  final List<Map<String, dynamic>> allThongTinItemNhap;
  final ThemDonHangModel donnhaphang;
  const ChiTietHoaDonScreen(
      {super.key,
      required this.donnhaphang,
      required this.allThongTinItemNhap,
      required this.phanbietNhapXuat});

  @override
  State<ChiTietHoaDonScreen> createState() => _ChiTietHoaDonScreenState();
}

class _ChiTietHoaDonScreenState extends State<ChiTietHoaDonScreen> {
  @override
  void initState() {
    super.initState();
    controllerHistoryRepo.hoaDonPDFControler.clear();
    controllerHistoryRepo.fetchSanPhamTrongTable(widget.donnhaphang.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 1,
          title: const Text("Chi tiết hóa đơn",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          backgroundColor: whiteColor,
          leading: IconButton(
              icon: const Image(
                image: AssetImage(backIcon),
                height: 17,
                color: Colors.black,
              ),
              onPressed: () {
                //out ra dashboard
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
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
                        printPDF(widget.donnhaphang.toJson(), context);
                      },
                      onTapCamera: () {
                        sharePDF(widget.donnhaphang.toJson(), context);
                      },
                    ),
                  );
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
                no: widget.donnhaphang.no,
                billType: widget.donnhaphang.billType,
                bHcode: widget.donnhaphang.soHD,
                date: widget.donnhaphang.ngaytao,
                tongtien: widget.donnhaphang.tongthanhtoan,
                paymentSelected: widget.donnhaphang.payment,
                khachhang: widget.donnhaphang.khachhang,
              ),
              PhanCachWidget.space(),
              widget.phanbietNhapXuat == "NhapHang" ||
                      widget.phanbietNhapXuat == "HetHan"
                  ? DanhSachItemDaChonNhapHangWidget(
                      selectedItems: widget.allThongTinItemNhap,
                    )
                  : DanhSachItemDaChonXuatHangWidget(
                      selectedItems: widget.allThongTinItemNhap,
                      blockOnPress: true,
                      reLoadOnDeleteXuatHang: () {},
                    ),
              PhanCachWidget.space(),
              TomTatYeuCauWidget(
                totalQuantity: widget.donnhaphang.tongsl,
                totalPrice: widget.donnhaphang.tongtien,
                giamgia: widget.donnhaphang.giamgia,
                no: widget.donnhaphang.no,
                tong: widget.donnhaphang.tongthanhtoan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
