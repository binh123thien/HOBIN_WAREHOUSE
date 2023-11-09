import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/phanphoihanghoa.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/widget/chitiethanghoa/chinhsua_chitiethanghoa.dart';
import '../../../../common_widgets/dialog/dialog.dart';
import '../../../../common_widgets/network/network.dart';
import '../../../../constants/color.dart';
import '../../../../repository/goods_repository/good_repository.dart';
import '../add/widget/card_add_widget.dart';
import 'widget/chitiethanghoa/location_hanghoa_widget.dart';
import 'widget/chitiethanghoa/thongtin_hanghoa_widget.dart';
import 'widget/chitiethanghoa/thongke_hanghoa_widget.dart';

class ChiTietHangHoaScreen extends StatefulWidget {
  final dynamic hanghoa;
  const ChiTietHangHoaScreen({super.key, this.hanghoa});

  @override
  State<ChiTietHangHoaScreen> createState() => _ChiTietHangHoaScreenState();
}

class _ChiTietHangHoaScreenState extends State<ChiTietHangHoaScreen> {
  final controllerGoodRepo = Get.put(GoodRepository());
  late dynamic hanghoa;

  @override
  void initState() {
    super.initState();
    hanghoa = widget.hanghoa;
    //load location data
    controllerGoodRepo.listLocationHangHoaSi.clear();
    _getLocationData();
  }

  //load dữ liệu location hàng hóa Sỉ
  Future<void> _getLocationData() async {
    String macode = widget.hanghoa["macode"];
    List<Map<String, dynamic>> locationData =
        await controllerGoodRepo.getLocationData(macode);
    controllerGoodRepo.listLocationHangHoaSi.addAll(locationData);
  }

  Future<void> _showOption() async {
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return SizedBox(
          height: hanghoa["phanloai"] == "bán lẻ"
              ? size.height * 0.23
              : size.height * 0.3,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Tùy chọn"),
            ),
            hanghoa["phanloai"] == "bán sỉ"
                ? CardAdd(
                    icon: shareIcon,
                    title: "Phân phối",
                    onTap: () {
                      NetWork.checkConnection().then((value) {
                        if (value == "Not Connected") {
                          MyDialog.showAlertDialogOneBtn(
                              context,
                              "Không có Internet",
                              "Vui lòng kết nối internet và thử lại sau");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhanPhoiHangHoaScreen(
                                    hanghoaSi: widget.hanghoa)),
                          ).then((_) {
                            Navigator.pop(context); // Tắt showModalBottomSheet
                          });
                        }
                      });
                    },
                  )
                : const SizedBox(),
            CardAdd(
              icon: editIcon,
              title: "Chỉnh sửa",
              onTap: () {
                NetWork.checkConnection().then((value) {
                  if (value == "Not Connected") {
                    MyDialog.showAlertDialogOneBtn(context, "Không có Internet",
                        "Vui lòng kết nối internet và thử lại sau");
                  } else {
                    // đóng bottom sheet
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChinhSuaChiTietHangHoaScreen(
                              updateChinhSuaHangHoa: hanghoa)),
                    ).then((value) {
                      //xóa hình ảnh trong list tạm
                      if (value == true) {
                        setState(() {
                          hanghoa = hanghoa;
                        });
                        // else (set State thông tin Hang hoa vừa chỉnh sửa)
                      } else {
                        setState(() {
                          hanghoa = value;
                        });
                      }
                    });
                  }
                });
              },
            ),
            CardAdd(
              icon: deleteIcon,
              title: "Xóa",
              onTap: () {
                NetWork.checkConnection().then((value) {
                  if (value == "Not Connected") {
                    MyDialog.showAlertDialogOneBtn(context, "Không có Internet",
                        "Vui lòng kết nối internet và thử lại sau");
                  } else {
                    MyDialog.showAlertDialog(
                        context, 'Xác nhận', 'Bạn muốn xóa hàng hóa này?', 0,
                        () {
                      controllerGoodRepo
                          .deleteHangHoaByTen(hanghoa["tensanpham"]);

                      //xóa hình ảnh của hàng hóa đó
                      if (hanghoa['photoGood'] != '') {
                        final imageRef = FirebaseStorage.instance
                            .refFromURL(hanghoa['photoGood']);
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
                  }
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
      backgroundColor: whiteColor,
      appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: const Text("Chi tiết hàng hóa",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
          backgroundColor: whiteColor,
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
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 1,
                    child: (hanghoa is Map && hanghoa.containsKey("photoGood"))
                        ? (hanghoa["photoGood"].length == 0
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(image: AssetImage(hanghoaIcon)),
                              )
                            : CachedNetworkImage(
                                imageUrl: hanghoa["photoGood"].toString(),
                                width: 300,
                                height: 300,
                                fit: BoxFit.fill,
                              ))
                        : Container(),
                  ),
                ),
              ),
              Text(
                hanghoa["tensanpham"],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ThongTinHangHoaWidget(hanghoa: hanghoa),
              ThongKeHangHoaWidget(hanghoa: hanghoa),
              LocationHangHoaWidget(hanghoa: hanghoa)
            ],
          ),
        ),
      ),
    );
  }
}
