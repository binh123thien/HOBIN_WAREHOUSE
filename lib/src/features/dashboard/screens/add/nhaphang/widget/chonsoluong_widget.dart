import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../constants/color.dart';

class ChonSoLuongWidget extends StatefulWidget {
  final int phanBietNhapXuat;
  const ChonSoLuongWidget({
    super.key,
    required this.phanBietNhapXuat,
  });

  @override
  State<ChonSoLuongWidget> createState() => _ChonSoLuongWidgetState();
}

class _ChonSoLuongWidgetState extends State<ChonSoLuongWidget> {
  final TextEditingController _controllerSoluong = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.27,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text("Nhập số lượng"),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    return oneCharacter(value!);
                  },
                  controller: _controllerSoluong,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(fontSize: 15),
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.phanBietNhapXuat == 1
                                  ? blueColor
                                  : mainColor,
                              width: 2)),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Nhập số lượng'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          widget.phanBietNhapXuat == 1 ? blueColor : mainColor,
                      side: BorderSide(
                          color: widget.phanBietNhapXuat == 1
                              ? blueColor
                              : mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(_controllerSoluong.text);
                      }
                    },
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
