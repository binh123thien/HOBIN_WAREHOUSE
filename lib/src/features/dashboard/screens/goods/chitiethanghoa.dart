import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dialog/dialog.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/phanphoihanghoa.dart';

import '../../../../constants/color.dart';
import '../../../../repository/goods_repository/good_repository.dart';
import 'widget/chitiethanghoa/card_chitiethanghoa.dart';
import 'widget/chitiethanghoa/chinhsua_chitiethanghoa.dart';
import 'widget/chitiethanghoa/thongke_hanghoa.dart';

class ChiTietHangHoaScreen extends StatefulWidget {
  final dynamic hanghoa;
  const ChiTietHangHoaScreen({super.key, this.hanghoa});

  @override
  State<ChiTietHangHoaScreen> createState() => _ChiTietHangHoaScreenState();
}

class _ChiTietHangHoaScreenState extends State<ChiTietHangHoaScreen> {
  final controllerGoodRepo = Get.put(GoodRepository());
  //truyền list tạm updatehanghoa qua trang chỉnh sửa,
  //cũng là biến show giá trị của trang này là để nhận giá trị sau khi được update
  late dynamic updatehanghoa;
  @override
  void initState() {
    updatehanghoa = widget.hanghoa;
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
        title: const Text("Chi tiết hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          updatehanghoa["phanloai"] == "bán sỉ"
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhanPhoiHangHoaScreen(
                                hanghoaSi: updatehanghoa,
                              )),
                    );
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                  ),
                )
              : const SizedBox(),
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
            onSelected: ((valueMenu) {
              if (valueMenu == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChinhSuaChiTietHangHoaScreen(
                          updateChinhSuaHangHoa: updatehanghoa)),
                ).then((newvalue) {
                  //'value' là giá trị được return từ trang Chỉnh sửa
                  if (newvalue == true) {
                    setState(() {
                      updatehanghoa = updatehanghoa;
                    });
                  } else {
                    setState(() {
                      updatehanghoa = newvalue;
                    });
                  }
                });
              }
              if (valueMenu == 2) {
                MyDialog.showAlertDialog(
                    context, 'Xác nhận', 'Bạn muốn xóa hàng hóa này?', () {
                  controllerGoodRepo
                      .deleteHangHoaByTen(updatehanghoa["tensanpham"]);

                  //xóa hình ảnh của hàng hóa đó
                  if (updatehanghoa['photoGood'] != '') {
                    final imageRef = FirebaseStorage.instance
                        .refFromURL(updatehanghoa['photoGood']);
                    //xóa hình ảnh qua path imageRef
                    FirebaseStorage.instance
                        .ref()
                        .child(imageRef.fullPath)
                        .delete();
                  }
                  //===============end xóa hình=================
                  //pop dialog
                  Navigator.of(context).pop();
                  //Chờ 1s để cập nhật dữ liệu trên db, sau đó pop trang chi tiết hàng hóa
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                });
              }
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      icon: updatehanghoa["photoGood"] == ''
                          ? Image.asset(cameraIcon)
                          : CachedNetworkImage(
                              imageUrl: updatehanghoa["photoGood"].toString(),
                              width: 300,
                              height: 300,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              Text(
                updatehanghoa["tensanpham"],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ChiTietHangHoa(
                macode: updatehanghoa["macode"],
                gianhap: updatehanghoa["gianhap"],
                giaban: updatehanghoa["giaban"],
                phanloai: updatehanghoa["phanloai"],
                donvi: updatehanghoa["donvi"],
                danhmuc: updatehanghoa["danhmuc"],
              ),
              ThongKeHangHoa(
                tonkho: updatehanghoa["tonkho"],
                daban: updatehanghoa["daban"],
                donvi: updatehanghoa["donvi"],
              )
            ],
          ),
        ),
      ),
    );
  }
}
