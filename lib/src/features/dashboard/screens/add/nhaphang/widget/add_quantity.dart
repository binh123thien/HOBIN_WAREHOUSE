import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class AddQuantity extends StatefulWidget {
  const AddQuantity({
    super.key,
  });

  @override
  State<AddQuantity> createState() => _AddQuantityState();
}

class _AddQuantityState extends State<AddQuantity> {
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
                  const Text("Nhập số lượng", style: TextStyle(fontSize: 18)),
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
                      // controller: ,
                      maxLength: 20,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nhập số lượng nhập hàng'),
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
                                // createLocation();
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: const Text("Xác nhận"))),
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

  // createLocation() {
  //   final id = generateRandomCode(10);
  //   var newlocation = AddLocationModel(
  //       location: _AddLocationController.text.toUpperCase(),
  //       exp: "",
  //       id: id,
  //       soluong: 0);
  //   final goodsRepo = Get.put(GoodRepository());
  //   goodsRepo.createLocaion(newlocation, widget.hanghoa["macode"], id);
  // }
}
