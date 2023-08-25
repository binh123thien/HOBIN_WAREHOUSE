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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: size.height * 0.295,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Thêm vị trí", style: TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 150,
                width: size.width - 30,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _AddLocationController,
                      maxLength: 8,
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nhập vị trí mới'),
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
