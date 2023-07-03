import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/chonhanghoa_controller.dart';

import '../../../../common_widgets/bottom_sheet_pdf.dart';
import '../../../../common_widgets/printting.dart';
import 'widget/chitietdonhang/table_chitietdonhang_widget.dart';
import 'widget/chitietdonhang/total_price_chitietdonhang_widget.dart';
import 'widget/chitietdonhang_moi/tieude_chitietdonhang.dart';

class ChiTietHoaDonNew extends StatefulWidget {
  //truyền model qua trang thêm đơn bán
  final model;
  final num sumPrice;
  final num disCount;
  final num no;
  final int sumItem;
  final int paymentSelected;
  final String maHD;
  final String date;
  final int phanbietNhapXuat;
  final String khachhang;
  final String billType;
  const ChiTietHoaDonNew(
      {super.key,
      required this.sumPrice,
      required this.sumItem,
      required this.disCount,
      required this.paymentSelected,
      required this.no,
      required this.maHD,
      required this.date,
      required this.phanbietNhapXuat,
      required this.khachhang,
      required this.billType,
      required this.model});

  @override
  State<ChiTietHoaDonNew> createState() => _ChiTietHoaDonNewState();
}

class _ChiTietHoaDonNewState extends State<ChiTietHoaDonNew> {
  final controller = Get.put(ChonHangHoaController());
  final ChonHangHoaController chonHangHoaController = Get.find();
  late List<dynamic> allHangHoa;

  @override
  void initState() {
    allHangHoa = chonHangHoaController.allHangHoaFireBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredList =
        allHangHoa.where((element) => element["soluong"] > 0).toList();
    final tongtien = widget.sumPrice - widget.no - widget.disCount;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage(tBackGround1), // where is this variable defined?
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: IconButton(
            icon: const Image(
              image: AssetImage(backIcon),
              height: 20,
              color: whiteColor,
            ),
            onPressed: () {
              for (var element in allHangHoa) {
                element["soluong"] = 0;
              }
              setState(() {
                controller.loadAllHangHoa();
              });
              Navigator.of(context).pop(allHangHoa);
            }),
        title: const Text(
          "Chi tiết đơn hàng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
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
                      printPDF(widget.model, context);
                    },
                    onTapCamera: () {
                      sharePDF(widget.model, context);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.print, size: 35))
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            TieuDeChiTietDonHang(
              no: widget.no,
              billType: widget.billType,
              bHcode: widget.maHD,
              date: widget.date,
              tongtien: tongtien,
              paymentSelected: widget.paymentSelected,
              khachhang: widget.khachhang,
            ),
            const Divider(),
            const Text("Chi tiết hóa đơn",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            TableChiTietDonHang(
              filteredList: filteredList,
              phanbietNhapXuat: widget.phanbietNhapXuat,
            ),
            const Divider(),
            TotalPriceChiTietDonHangWidget(
              sumItem: widget.sumItem,
              sumPrice: widget.sumPrice,
              disCount: widget.disCount,
              tienno: widget.no,
              billType: widget.billType,
            ),
          ],
        ),
      )),
    );
  }
}
