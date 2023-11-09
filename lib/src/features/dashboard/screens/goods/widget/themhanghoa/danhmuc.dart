import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/widget/themhanghoa/chon_danhmuc.dart';

import '../../../../controllers/goods/chondanhmuc_controller.dart';

class DanhMucHang extends StatefulWidget {
  const DanhMucHang({super.key});

  @override
  State<DanhMucHang> createState() => _DanhMucHangState();
}

class _DanhMucHangState extends State<DanhMucHang> {
  final ChonDanhMucController controllerDanhMuc =
      Get.put(ChonDanhMucController());

  // ĐỔi danhmucSelected thành RxList luôn để 1 cùng kiểu dữ liệu, 2 quan sát đc giá trị thay đổi
  late RxList<String> danhmucSelected = controllerDanhMuc.selectedDanhMuc;

  @override
  void initState() {
    //chống await ở showBottomSheet
    controllerDanhMuc.loadDanhMuc();
    super.initState();
  }

//=============================ShowButtonShweet===========================//
  Future<void> _showDanhSachDanhMuc() async {
    controllerDanhMuc.loadDanhMuc();
    List<String>? result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return DanhSachDanhMuc(
          selectedUnits: danhmucSelected,
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (result != null) {
      setState(() {
        danhmucSelected.value = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Obx thay đổi UI khi dữ liệu trong list danhmucSelected thay đổi
    return Obx(() {
      final size = MediaQuery.of(context).size;
      List<Widget> chips = danhmucSelected.map((unit) {
        return Chip(
          deleteIconColor: whiteColor,
          backgroundColor: mainColor,
          label: Text(unit,
              style: const TextStyle(fontSize: 15, color: whiteColor)),
          onDeleted: () {
            setState(() {
              danhmucSelected.remove(unit);
            });
          },
        );
      }).toList();
      return SizedBox(
        width: size.width,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showDanhSachDanhMuc();
                },
                child: Stack(children: [
                  TextFormField(
                    enabled:
                        false, // không cho nhập liệu trực tiếp vào TextField
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      suffixIcon: Icon(Icons.navigate_next_sharp, size: 35),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                  ),
                  if (chips.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Wrap(
                        spacing: 8,
                        children: chips,
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
