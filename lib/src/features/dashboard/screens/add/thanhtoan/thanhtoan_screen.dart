import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../nhaphang/widget/danhsachitemdachon/danhsachsanpham_dachon.dart';
import 'widget/choose_khachhang_widget.dart';
import 'widget/giamgia_widget.dart';

class ThanhToanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemNhap;
  const ThanhToanScreen({super.key, required this.allThongTinItemNhap});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  Map<String, dynamic> khachhang = {};
  num giamgia = 0;
  num no = 0;
  void _reload(Map<String, dynamic> khachhangPicked) {
    setState(() {
      khachhang = khachhangPicked;
    });
  }

  void _giamGia() {
    // Khởi tạo FocusNode
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return GiamGiaWidget(focusNode: focusNode);
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          giamgia = num.tryParse(value)!;
        });
      }
    });
  }

  void _no() {
    // Khởi tạo FocusNode
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return GiamGiaWidget(focusNode: focusNode);
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          no = num.tryParse(value)!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 1,
        title: Text("Thanh Toán (${widget.allThongTinItemNhap.length})",
            style: const TextStyle(fontSize: 18, color: Colors.black)),
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
      body: Column(
        children: [
          ChooseKhachHangWidget(
            khachhang: khachhang,
            reload: _reload,
          ),
          PhanCachWidget.space(),
          DanhSachSanPhamDaChonWidget(
            selectedItems: widget.allThongTinItemNhap,
          ),
          PhanCachWidget.space(),
          InkWell(
            onTap: () {
              _giamGia();
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image(image: AssetImage(disCountIcon)),
                      ),
                      SizedBox(width: 7),
                      Text(
                        "Giảm giá",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      giamgia != 0
                          ? Text(
                              "-${formatCurrency(giamgia)}",
                              style: const TextStyle(
                                  fontSize: 16, color: cancelColor),
                            )
                          : const SizedBox(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PhanCachWidget.dotLine(context),
          ),
          InkWell(
            onTap: () {
              _no();
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image(
                          image: AssetImage(noIcon),
                          color: successColor,
                        ),
                      ),
                      SizedBox(width: 7),
                      Text(
                        "Nợ",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      no != 0
                          ? Text(
                              formatCurrency(no),
                              style: const TextStyle(
                                  fontSize: 16, color: successColor),
                            )
                          : const SizedBox(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          PhanCachWidget.space(),
        ],
      ),
    );
  }
}
