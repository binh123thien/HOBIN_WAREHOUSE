import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../constants/color.dart';

class ThayDoiGiaWidget extends StatefulWidget {
  const ThayDoiGiaWidget({super.key});

  @override
  State<ThayDoiGiaWidget> createState() => _ThayDoiGiaWidgetState();
}

class _ThayDoiGiaWidgetState extends State<ThayDoiGiaWidget> {
  final TextEditingController _controllerThayDoiGia = TextEditingController();
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
                const Text("Giá Nhập Hàng"),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    return oneCharacter(value!);
                  },
                  controller: _controllerThayDoiGia,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 15),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blueColor, width: 2)),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Nhập giá'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: blueColor,
                      side: const BorderSide(color: blueColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(_controllerThayDoiGia.text);
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
