import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/add/add_location_model.dart';

import '../../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../../utils/utils.dart';

class AddLocation extends StatefulWidget {
  final dynamic hanghoa;
  const AddLocation({
    super.key,
    required this.hanghoa,
  });

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController _AddLocationController = TextEditingController();
  List<String> items = <String>[
    "Chọn",
    "A201",
    "A202",
  ];
  String dropdownValue = "Chọn";
  @override
  Widget build(BuildContext context) {
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
                    const Text("Vị trí",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          enabled: (value != 'Chọn'),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Text("Ngày hết hạn "),
                    const Text(
                      "Số lượng",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    TextFormField(
                      controller: _AddLocationController,
                      maxLength: 8,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nhập số lượng'),
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
                                createLocation();
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.of(context).pop();
                                });
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

  createLocation() {
    final id = generateRandomCode(10);
    var newlocation = AddLocationModel(
        location: _AddLocationController.text.toUpperCase(),
        exp: "",
        id: id,
        soluong: 0);
    final goodsRepo = Get.put(GoodRepository());
    goodsRepo.createLocaion(newlocation, widget.hanghoa["macode"], id);
  }
}
