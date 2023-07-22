import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/phanphoihanghoa.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/widget/chitiethanghoa/chinhsua_chitiethanghoa.dart';
import '../../../../common_widgets/dialog/dialog.dart';
import '../../../../constants/color.dart';
import '../../../../repository/goods_repository/good_repository.dart';
import '../add/widget/card_add_widget.dart';
import 'widget/chitiethanghoa/card_chitiethanghoa.dart';
import 'widget/chitiethanghoa/thongke_hanghoa.dart';

class ChiTietHangHoaScreen extends StatefulWidget {
  final dynamic hanghoa;
  const ChiTietHangHoaScreen({super.key, this.hanghoa});

  @override
  State<ChiTietHangHoaScreen> createState() => _ChiTietHangHoaScreenState();
}

class _ChiTietHangHoaScreenState extends State<ChiTietHangHoaScreen> {
  final controllerGoodRepo = Get.put(GoodRepository());
  late dynamic hanghoanew;
  @override
  void initState() {
    super.initState();
    hanghoanew = widget.hanghoa;
  }

  Future<void> _showOption() async {
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return SizedBox(
          height: hanghoanew["phanloai"] == "bán lẻ"
              ? size.height * 0.23
              : size.height * 0.3,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Tùy chọn"),
            ),
            hanghoanew["phanloai"] == "bán sỉ"
                ? CardAdd(
                    icon: shareIcon,
                    title: "Phân phối",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhanPhoiHangHoaScreen(
                                hanghoaSi: widget.hanghoa)),
                      ).then((_) {
                        Navigator.pop(context); // Tắt showModalBottomSheet
                      });
                    },
                  )
                : const SizedBox(),
            CardAdd(
              icon: editIcon,
              title: "Chỉnh sửa",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChinhSuaChiTietHangHoaScreen(
                          updateChinhSuaHangHoa: hanghoanew)),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      hanghoanew = hanghoanew;
                    });
                  } else {
                    setState(() {
                      hanghoanew = value;
                    });
                  }
                });
              },
            ),
            CardAdd(
              icon: deleteIcon,
              title: "Xóa",
              onTap: () {
                MyDialog.showAlertDialog(
                    context, 'Xác nhận', 'Bạn muốn xóa hàng hóa này?', () {
                  controllerGoodRepo
                      .deleteHangHoaByTen(hanghoanew["tensanpham"]);

                  //xóa hình ảnh của hàng hóa đó
                  if (hanghoanew['photoGood'] != '') {
                    final imageRef = FirebaseStorage.instance
                        .refFromURL(hanghoanew['photoGood']);
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
                    Navigator.of(context).pop();
                  });
                });
              },
            )
          ]),
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
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
            IconButton(
              onPressed: () {
                _showOption();
              },
              icon: const Image(
                image: AssetImage(moreAppbarIcon),
                width: 25,
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: SizedBox(
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
                      icon: (hanghoanew is Map &&
                              hanghoanew.containsKey("photoGood"))
                          ? (hanghoanew["photoGood"].length == 0
                              ? Image.asset(cameraIcon)
                              : CachedNetworkImage(
                                  imageUrl: hanghoanew["photoGood"].toString(),
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.fill,
                                ))
                          : Container(), // Handle the case if the condition isn't met
                    ),
                  ),
                ),
              ),
              Text(
                hanghoanew["tensanpham"],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ChiTietHangHoa(
                macode: hanghoanew["macode"],
                gianhap: hanghoanew["gianhap"],
                giaban: hanghoanew["giaban"],
                phanloai: hanghoanew["phanloai"],
                donvi: hanghoanew["donvi"],
                danhmuc: hanghoanew["danhmuc"],
              ),
              ThongKeHangHoa(
                tonkho: hanghoanew["tonkho"],
                daban: hanghoanew["daban"],
                donvi: hanghoanew["donvi"],
              )
            ],
          ),
        ),
      ),
    );
  }
}
