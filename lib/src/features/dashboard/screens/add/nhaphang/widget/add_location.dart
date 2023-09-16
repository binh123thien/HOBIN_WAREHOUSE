import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/date_picker/date_picker.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';
import 'package:intl/intl.dart';

import '../../../../../../repository/goods_repository/good_repository.dart';

class AddLocation extends StatefulWidget {
  final int phanBietNhapXuat;
  final dynamic hanghoa;
  const AddLocation({
    super.key,
    required this.hanghoa,
    required this.phanBietNhapXuat,
  });

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _AddLocationController = TextEditingController();
  late String textExpire = '';
  late Map<String, dynamic> mapNhapHang;

  List<String> items = <String>[
    "Chọn",
    "A201",
    "A202",
  ];
  String dropdownValue = "Chọn";
  @override
  Widget build(BuildContext context) {
    ThemeData datePickerTheme =
        MyTheme.getCustomDatePickerTheme(widget.phanBietNhapXuat);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Nhập thêm hàng", style: TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 300,
                width: size.width - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Vị trí: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              enabled: (value != 'Chọn'),
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ngày hết hạn: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          textExpire == ''
                              ? const Text(
                                  'Hãy bấm chọn',
                                  style: TextStyle(fontSize: 17),
                                )
                              : Text(
                                  textExpire,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 17),
                                ),
                          SizedBox(
                            width: 65,
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: datePickerTheme,
                                      child: child!,
                                    );
                                  },
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      String newDate = DateFormat('dd/MM/yyyy')
                                          .format(selectedDate);
                                      textExpire = newDate;
                                    });
                                    // updateExpirationDate(index, newDate);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: widget.phanBietNhapXuat == 1
                                    ? blueColor
                                    : mainColor,
                                side: BorderSide(
                                    color: widget.phanBietNhapXuat == 1
                                        ? blueColor
                                        : mainColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // giá trị này xác định bán kính bo tròn
                                ),
                              ),
                              child: const Text(
                                'Chọn',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Số lượng",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          return nonZeroInput(value!);
                        },
                        controller: _AddLocationController,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
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
                        ),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    textExpire != '' &&
                                    dropdownValue != 'Chọn') {
                                  createListNhapHang();
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  Get.snackbar(
                                      'Lỗi', 'Vui lòng điền hết thông tin',
                                      colorText: Colors.red);
                                }
                              },
                              child: const Text("Thêm"))),
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

  createListNhapHang() {
    mapNhapHang = {
      'macode': widget.hanghoa['macode'],
      'tensp': widget.hanghoa['tensanpham'],
      'location': dropdownValue,
      'expire': textExpire,
      'soluong': _AddLocationController.text,
    };
    final goodsRepo = Get.put(GoodRepository());
    goodsRepo.listNhapXuathang.add(mapNhapHang);
  }
}
