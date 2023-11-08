import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';

import '../../../../../../utils/validate/validate.dart';
import '../../../../controllers/goods/chondonvi_controller.dart';
import 'chon_donvi.dart';

class DonVi extends StatefulWidget {
  const DonVi({super.key});

  @override
  State<DonVi> createState() => _DonViState();
}

class _DonViState extends State<DonVi> with InputValidationMixin {
  final ChonDonViController myController = Get.put(ChonDonViController());
  final controller = Get.put(ThemHangHoaController());

  @override
  void initState() {
    //chống await ở showBottomSheet
    myController.loadDonVi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showDanhSachDonVi() async {
      //lấy dữ liệu thay đổi từ hàm loadData bên trong repo controller
      myController.loadDonVi();
      final selectedDonvi = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return const DanhSachDonVi(); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
        },
      );
      if (selectedDonvi != null) {
        setState(() {
          controller.donviController.text = selectedDonvi;
        });
      }
    }

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showDanhSachDonVi();
              },
              child: AbsorbPointer(
                child: TextFormField(
                  validator: (value) {
                    return oneCharacter(value!);
                  },
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: Font.sizes(context)[1]),
                    hintText: 'Chọn một phần tử',
                    suffixIcon: const Icon(Icons.navigate_next_sharp, size: 35),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 2),
                    ),
                  ),
                  controller: controller.donviController,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
