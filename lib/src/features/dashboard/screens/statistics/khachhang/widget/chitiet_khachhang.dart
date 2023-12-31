import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
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
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: whiteColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
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
              },
              icon: const Icon(Icons.edit, color: darkColor)),
          IconButton(
              onPressed: () {
                MyDialog.showAlertDialog(
                    context,
                    'Xóa khách hàng!',
                    'Bạn có chắc chắn muốn xóa khách hàng?\n\nLưu ý: Khi xóa khách hàng tất cả dữ liệu của khách hàng sẽ mất.',
                    0, () {
                  controller
                      .deleteKhachHang(khachhangCurrent["maKH"])
                      .then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                });
              },
              icon: const Icon(Icons.delete, color: darkColor)),
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
                      side: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.circular(50)),
                  color: whiteColor,
                  child: Center(
                      child: Text(
                    widget.khachhang["tenkhachhang"]
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(fontSize: 50),
                  )),
                ),
              ),
            ),
            ThongTinKhachHang(khachhang: khachhangCurrent),
          ],
        ),
      ),
    );
  }
}
