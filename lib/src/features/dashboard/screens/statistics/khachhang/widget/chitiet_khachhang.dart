import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/khachhang/widget/chitietkhachhang/thongtin_khachhang.dart';

import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../repository/statistics_repository/khachhang_repository.dart';
import 'chitietkhachhang/chinhsua_thongtinkhachhang.dart';

class KhachHangDetailScreen extends StatefulWidget {
  final dynamic khachhang;
  const KhachHangDetailScreen({super.key, this.khachhang});

  @override
  State<KhachHangDetailScreen> createState() => _KhachHangDetailScreenState();
}

class _KhachHangDetailScreenState extends State<KhachHangDetailScreen> {
  final controller = Get.put(KhachHangRepository());
  late dynamic khachhangCurrent;
  @override
  void initState() {
    khachhangCurrent = widget.khachhang;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(khachhangCurrent["loai"],
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 30, color: darkColor),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Chỉnh sửa",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  "Xóa",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
            onSelected: ((value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChinhSuaThongTinKhachHangScreen(
                          khachhang: khachhangCurrent)),
                ).then((value) {
                  setState(() {
                    khachhangCurrent = value;
                  });
                });
              }
              if (value == 2) {
                MyDialog.showAlertDialog(context, 'Xóa khách hàng!',
                    'Bạn có chắc chắn muốn xóa khách hàng?', () {
                  controller
                      .deleteKhachHang(khachhangCurrent["maKH"])
                      .then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                });
              }
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 1,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Image(image: AssetImage(khachhangIcon))),
                ),
              ),
            ),
            ThongTinKhachHang(khachhang: khachhangCurrent),
          ],
        ),
      ),
    ));
  }
}