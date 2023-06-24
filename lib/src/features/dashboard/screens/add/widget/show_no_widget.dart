import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/nhaphang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/taodonhang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/maxmin_input_textformfield.dart';

class ShowNo extends StatefulWidget {
  final int phanbietNhapXuat;
  final num sumPrice;
  const ShowNo(
      {super.key, required this.sumPrice, required this.phanbietNhapXuat});

  @override
  State<ShowNo> createState() => _ShowNoState();
}

class _ShowNoState extends State<ShowNo> {
  final controllerBanHang = Get.put(TaoDonHangController());
  final controllerNhaphang = Get.put(NhapHangController());
  num no = 0;

  void _onSaveButtonPressed() {
    setState(() {
      if (widget.phanbietNhapXuat == 0) {
        no = num.tryParse(controllerBanHang.noController.text) ?? 0;
      } else {
        no = num.tryParse(controllerNhaphang.noNhapHangController.text) ?? 0;
      }
    });
    Navigator.of(context).pop(no);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print(widget.sumPrice);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: size.height * 0.285,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.phanbietNhapXuat == 0
                          ? "Tiền nợ của khách"
                          : "Tiền nợ nhà cung cấp",
                      style: const TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 120,
                width: size.width - 30,
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.phanbietNhapXuat == 0
                          ? controllerBanHang.noController
                          : controllerNhaphang.noNhapHangController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        NumberFormatter(maxValue: (widget.sumPrice).round()),
                      ],
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nhập số tiền nợ'),
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
      ),
    );
  }
}
