import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../models/themdonhang_model.dart';
import '../nhaphang/widget/danhsachitemdachon/danhsachsanpham_dachon.dart';
import '../widget/chitietdonhang_moi/tieude_chitietdonhang.dart';
import 'widget/tomtatyeucau.dart';

class ChiTietHoaDonScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemNhap;
  final ThemDonHangModel donnhaphang;
  const ChiTietHoaDonScreen(
      {super.key,
      required this.donnhaphang,
      required this.allThongTinItemNhap});

  @override
  State<ChiTietHoaDonScreen> createState() => _ChiTietHoaDonScreenState();
}

class _ChiTietHoaDonScreenState extends State<ChiTietHoaDonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.of(context).pop();
            }),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TieuDeChiTietDonHang(
              no: widget.donnhaphang.no,
              billType: widget.donnhaphang.billType,
              bHcode: widget.donnhaphang.soHD,
              date: widget.donnhaphang.ngaytao,
              tongtien: widget.donnhaphang.tongtien,
              paymentSelected: widget.donnhaphang.payment,
              khachhang: widget.donnhaphang.khachhang,
            ),
            PhanCachWidget.space(),
            DanhSachSanPhamDaChonWidget(
              selectedItems: widget.allThongTinItemNhap,
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
    );
  }
}
