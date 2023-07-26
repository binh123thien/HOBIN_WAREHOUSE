import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import 'widget/cardphanphoihang_widget.dart';

class DonePhanPhoiScreen extends StatefulWidget {
  final dynamic updatehanghoaSi;
  final dynamic updatehanghoaLe;
  final int chuyendoiLe;
  final int chuyendoiSi;
  final String dateTao;
  const DonePhanPhoiScreen(
      {super.key,
      this.updatehanghoaSi,
      this.updatehanghoaLe,
      required this.chuyendoiLe,
      required this.chuyendoiSi,
      required this.dateTao});

  @override
  State<DonePhanPhoiScreen> createState() => _DonePhanPhoiScreenState();
}

class _DonePhanPhoiScreenState extends State<DonePhanPhoiScreen> {
  final controller = Get.put(ChonHangHoaLeController());

  late dynamic doneUpdatehanghoaSi;
  late dynamic doneUpdatehanghoaLe;
  late int chuyendoiLeTang;
  late int chuyendoiSiGiam;
  late RxInt soluongLe = 0.obs;
  late RxInt soluongSi = 0.obs;

  @override
  void initState() {
    doneUpdatehanghoaSi = widget.updatehanghoaSi;
    doneUpdatehanghoaLe = widget.updatehanghoaLe;
    chuyendoiLeTang = widget.chuyendoiLe;
    chuyendoiSiGiam = widget.chuyendoiSi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get LichSu vừa tạo
    controller.getLichSuCD(widget.dateTao).then((querySnapshot) {
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        soluongSi.value = data['soluongSi'];
        soluongLe.value = data['soluongLe'];
      }
    });
    //=============
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              //trả về trang goods Sỉ
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
      ),
      backgroundColor: backGroundDefaultFigma,
      body: SizedBox(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(successIcon),
                      height: 35,
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      'Phân phối hàng hóa thành công!',
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                CardPhanPhoiHang(
                    soluong: soluongSi,
                    phanBietSiLe: true,
                    slchuyendoi: chuyendoiSiGiam,
                    imageProduct: doneUpdatehanghoaSi['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : doneUpdatehanghoaSi['photoGood'],
                    donViProduct: doneUpdatehanghoaSi['donvi'],
                    updatehanghoa: doneUpdatehanghoaSi),
                const Icon(
                  Icons.arrow_downward_outlined,
                ),
                CardPhanPhoiHang(
                    soluong: soluongLe,
                    phanBietSiLe: false,
                    slchuyendoi: chuyendoiLeTang,
                    imageProduct: doneUpdatehanghoaLe['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : doneUpdatehanghoaLe['photoGood'],
                    donViProduct: doneUpdatehanghoaLe['donvi'],
                    updatehanghoa: doneUpdatehanghoaLe),
              ],
            )
          ],
        ),
      ),
    );
  }
}
