import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import '../../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../common_widgets/network/network.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../utils/utils.dart';
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
        .where((doc) =>
            doc["khachhang"] == widget.tenkhachhang &&
            doc["no"] != 0 &&
            doc["trangthai"] != "Hủy")
        .toList();
    allDonHangCurent.sort((a, b) => a['soHD'].compareTo(b['soHD']));
    double tongno = allDonHangCurent.fold(0.0, (sum, doc) {
      if (doc["no"] != null) {
        return sum + doc["no"];
      } else {
        return sum;
      }
    });
    Future<void> showTraNo(BuildContext context) async {
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

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 1,
        title: Text("Danh sách đơn nợ",
            style: TextStyle(
                fontSize: Font.sizes(context)[2],
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        backgroundColor: whiteColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                size: size.width * 0.06, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.038,
            color: processColor,
            child: Center(
              child: Text(
                "Tổng nợ: ${formatCurrency(tongno)}",
                style: TextStyle(
                    fontSize: Font.sizes(context)[1], color: whiteColor),
              ),
            ),
          ),
          CardListDanhSachNo(
            docs: allDonHangCurent,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: size.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: size.width - 30,
                height: size.height * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: processColor,
                    side: const BorderSide(color: processColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    NetWork.checkConnection().then((value) {
                      if (value == "Not Connected") {
                        MyDialog.showAlertDialogOneBtn(
                            context,
                            "Không có Internet",
                            "Vui lòng kết nối internet và thử lại sau");
                      } else {
                        showTraNo(context);
                      }
                    });
                  },
                  child: Text(
                    'Trả nợ',
                    style: TextStyle(fontSize: Font.sizes(context)[2]),
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
