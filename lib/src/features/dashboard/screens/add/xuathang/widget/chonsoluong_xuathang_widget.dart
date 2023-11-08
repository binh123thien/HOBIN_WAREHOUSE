import 'package:flutter/material.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../utils/validate/formsoluong.dart';

class ChonSoLuongXuatHangWidget extends StatefulWidget {
  // 0 là xuat hàng
  final int phanBietNhapXuat;
  final num tonkho;
  final FocusNode focusNode;
  const ChonSoLuongXuatHangWidget(
      {super.key,
      required this.focusNode,
      required this.tonkho,
      required this.phanBietNhapXuat});

  @override
  State<ChonSoLuongXuatHangWidget> createState() =>
      _ChonSoLuongXuatHangWidgetState();
}

class _ChonSoLuongXuatHangWidgetState extends State<ChonSoLuongXuatHangWidget> {
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
                Text("Nhập số lượng",
                    style: TextStyle(fontSize: Font.sizes(context)[2])),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Tồn kho: ${widget.tonkho}",
                        style: TextStyle(fontSize: Font.sizes(context)[0])),
                  ],
                ),
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
                        inputFormatters: [
                          MaxValueTextInputFormatter(widget.tonkho)
                        ],
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 15),
                          contentPadding: const EdgeInsets.only(left: 10),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.phanBietNhapXuat == 1
                                    ? blueColor
                                    : mainColor,
                                width: 2),
                            borderRadius: BorderRadius.zero,
                          ),
                          hintText: 'Nhập số lượng',
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
                          backgroundColor: widget.phanBietNhapXuat == 1
                              ? blueColor
                              : mainColor,
                          side: BorderSide(
                              color: _controllerSoLuong.text.isNotEmpty
                                  ? widget.phanBietNhapXuat == 1
                                      ? blueColor
                                      : mainColor
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
                        child: Text(
                          'Xác nhận',
                          style: TextStyle(fontSize: Font.sizes(context)[1]),
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
