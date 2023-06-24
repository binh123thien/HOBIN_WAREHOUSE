import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/taodonhang_controller.dart';

import '../../Widget/add/maxmin_input_textformfield.dart';

class ShowDiscount extends StatefulWidget {
  final int phanbietNhapXuat;
  final num sumPrice;
  const ShowDiscount(
      {super.key, required this.sumPrice, required this.phanbietNhapXuat});

  @override
  State<ShowDiscount> createState() => _ShowDiscountState();
}

class _ShowDiscountState extends State<ShowDiscount> {
  final controllerBanHang = Get.put(TaoDonHangController());

  //giá trị của Toggle
  int _selectedIndex = 0;
  //bật tắt
  final List<bool> _selections = [true, false];

  num disCountPrice = 0;

  void _onItemToggled(int index) {
    if (_selectedIndex != index) {
      setState(() {
        //đổi công tắc, 1 cái bật thì 1 cái tắt
        _selections[index] = true;
        _selections[_selectedIndex] = false;

        _selectedIndex = index;
        controllerBanHang.giamgiaController.text;
        if (_selectedIndex == 0) {
          num discountPercent =
              num.tryParse(controllerBanHang.giamgiaController.text) ?? 0;
          controllerBanHang.giamgiaController.text =
              ((discountPercent * widget.sumPrice / 100).round()).toString();
        } else if (_selectedIndex == 1) {
          if (controllerBanHang.giamgiaController.text.isNotEmpty &&
              controllerBanHang.giamgiaController.text != "0") {
            num price =
                num.tryParse(controllerBanHang.giamgiaController.text) ?? 0;
            controllerBanHang.giamgiaController.text =
                ((price * 100 / widget.sumPrice).round()).toString();
          }
        }
      });
    }
  }

  void _onSaveButtonPressed() {
    String inputText = controllerBanHang.giamgiaController.text;
    if (_selectedIndex == 0) {
      disCountPrice = num.tryParse(inputText) ?? 0;
    } else {
      num discountPercent = num.tryParse(inputText) ?? 0;
      disCountPrice = (widget.sumPrice * discountPercent / 100).round();
    }
    setState(() {
      // controller.giamgiaController.text = _totalPrice.toString();
    });
    Navigator.of(context).pop(disCountPrice);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print(widget.sumPrice);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: size.height * 0.25,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Giảm giá", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 40,
                    child: ToggleButtons(
                      fillColor: mainColor,
                      borderColor: mainColor,
                      selectedColor: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      isSelected: _selections,
                      onPressed: _onItemToggled,
                      children: const [
                        Text('đ'),
                        Text('%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 125,
              width: size.width - 30,
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerBanHang.giamgiaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      if (_selectedIndex == 0)
                        NumberFormatter(maxValue: (widget.sumPrice).round()),
                      if (_selectedIndex == 1) NumberFormatter(maxValue: 100),
                    ],
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(fontSize: 15),
                      border: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2)),
                      contentPadding: EdgeInsets.zero,
                      labelText: _selectedIndex == 0
                          ? 'Nhập số tiền'
                          : 'Nhập phần trăm',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                        height: 50,
                        width: size.width - 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _onSaveButtonPressed,
                            child: const Text("Xong"))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
