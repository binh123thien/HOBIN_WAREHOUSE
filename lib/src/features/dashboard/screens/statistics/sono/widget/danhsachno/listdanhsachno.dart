import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      num? result = await showModalBottomSheet<num>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return ShowTraNo(
            tenkhachhang: widget.tenkhachhang,
            billType: widget.billType,
            tongno: tongno,
          );
        },
      );
      if (result != null) {
        setState(() {
          alldonhang = widget.billType == "NhapHang"
              ? controller.allDonNhapHangFirebase
              : controller.allDonBanHangFirebase;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Danh sách đơn nợ",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: showTraNo,
              icon: const Image(
                image: AssetImage(refundIcon),
                height: 28,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: CardListDanhSachNo(
          docs: allDonHangCurent,
        ),
      ),
    );
  }
}
