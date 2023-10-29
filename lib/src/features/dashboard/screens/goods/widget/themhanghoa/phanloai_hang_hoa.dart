import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';

class RadioButton extends StatefulWidget {
  final String phanloaiFb;
  const RadioButton({super.key, required this.phanloaiFb});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  final controller = Get.put(ThemHangHoaController());
  int selectedPhanLoai = 0;
  @override
  void initState() {
    super.initState();
    // Gán giá trị ban đầu thông qua biến tạm
    // initialSelected để lưu trữ giá trị được chọn ban đầu
    int initialSelected = widget.phanloaiFb == 'bán lẻ' ? 0 : 1;
    setState(() {
      //hiển thị UI lúc vào trang
      selectedPhanLoai = initialSelected;
      controller.phanloaiController.text =
          initialSelected == 0 ? 'bán lẻ' : 'bán sỉ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: 0,
          groupValue: selectedPhanLoai,
          activeColor: mainColor,
          onChanged: (value) {
            setState(() {
              selectedPhanLoai = value!;
              controller.phanloaiController.text = "bán lẻ";
              // print("phan loai:${selectedPhanLoai}");
              // print("phan loai:${controller.phanloaiController.text}");
            });
          },
        ),
        Text(
          'Bán lẻ',
          style: TextStyle(fontSize: Font.sizes(context)[1]),
        ),
        Radio(
          value: 1,
          groupValue: selectedPhanLoai,
          activeColor: mainColor,
          onChanged: (value) {
            setState(() {
              selectedPhanLoai = value!;
              controller.phanloaiController.text = "bán sỉ";
            });
          },
        ),
        Text(
          'Bán sỉ',
          style: TextStyle(fontSize: Font.sizes(context)[1]),
        ),
      ],
    );
  }
}
