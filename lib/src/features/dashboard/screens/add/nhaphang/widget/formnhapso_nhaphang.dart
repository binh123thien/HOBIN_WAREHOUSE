import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';

class FormNhapSoNhapHangWidget extends StatefulWidget {
  final String phanbietgianhapHoacSoluong;
  final FocusNode focusNode;
  const FormNhapSoNhapHangWidget(
      {super.key,
      required this.focusNode,
      required this.phanbietgianhapHoacSoluong});

  @override
  State<FormNhapSoNhapHangWidget> createState() =>
      _FormNhapSoNhapHangWidgetState();
}

class _FormNhapSoNhapHangWidgetState extends State<FormNhapSoNhapHangWidget> {
  final TextEditingController _controllerSoLuong = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.19,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                widget.phanbietgianhapHoacSoluong == "soluong"
                    ? const Text(
                        "Nhập số lượng",
                      )
                    : widget.phanbietgianhapHoacSoluong == "gianhap"
                        ? const Text(
                            "Nhập giá nhập hàng",
                          )
                        : const Text(
                            "Nhập giá xuất hàng",
                          ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      width: (MediaQuery.of(context).size.width - 30) * 7 / 10,
                      child: TextFormField(
                        focusNode: widget.focusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _controllerSoLuong,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 15),
                          contentPadding: const EdgeInsets.only(left: 10),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: blueColor, width: 2),
                            borderRadius: BorderRadius.zero,
                          ),
                          hintText:
                              widget.phanbietgianhapHoacSoluong == "soluong"
                                  ? "Nhập số lượng"
                                  : "Nhập giá trị",
                        ),
                      ),
                    ),
                    SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - 30) * 2.9 / 10,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: blueColor,
                          side: BorderSide(
                              color: _controllerSoLuong.text.isNotEmpty
                                  ? blueColor
                                  : Colors.grey[500]!),
                        ),
                        onPressed: _controllerSoLuong.text.isNotEmpty
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context)
                                      .pop(_controllerSoLuong.text);
                                }
                              }
                            : null,
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
