import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import 'card_listdanhsachno.dart';
import 'show_trano.dart';

class ListDanhSachNo extends StatefulWidget {
  final String tenkhachhang;
  final String billType;
  const ListDanhSachNo(
      {super.key, required this.tenkhachhang, required this.billType});

  @override
  State<ListDanhSachNo> createState() => _ListDanhSachNoState();
}

class _ListDanhSachNoState extends State<ListDanhSachNo> {
  final KhachHangController controller = Get.find();
  final controllerKhachHang = Get.put(KhachHangController());
  late List<dynamic> alldonhang;
  @override
  void initState() {
    alldonhang = widget.billType == "NhapHang"
        ? controller.allDonNhapHangFirebase
        : controller.allDonBanHangFirebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> allDonHangCurent = alldonhang
        .where(
            (doc) => doc["khachhang"] == widget.tenkhachhang && doc["no"] != 0)
        .toList();
    allDonHangCurent.sort((a, b) => a['soHD'].compareTo(b['soHD']));
    double tongno = allDonHangCurent.fold(0.0, (sum, doc) {
      if (doc["no"] != null) {
        return sum + doc["no"];
      } else {
        return sum;
      }
    });
    Future<void> showTraNo() async {
      final focusNode = FocusNode();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 100), () {
            focusNode.requestFocus();
          });
          return ShowTraNo(
            tenkhachhang: widget.tenkhachhang,
            billType: widget.billType,
            tongno: tongno,
            focusNode: focusNode,
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            SnackBarWidget.showSnackBar(
                context, "Trả nợ thành công!", successColor);
            alldonhang = widget.billType == "NhapHang"
                ? controller.allDonNhapHangFirebase
                : controller.allDonBanHangFirebase;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 1,
        title: const Text("Danh sách đơn nợ",
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CardListDanhSachNo(
          docs: allDonHangCurent,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: blueColor,
                    side: const BorderSide(color: blueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: showTraNo,
                  child: const Text(
                    'Trả nợ',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
