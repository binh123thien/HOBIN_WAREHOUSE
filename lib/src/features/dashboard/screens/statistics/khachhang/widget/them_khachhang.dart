import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

import '../../../../../../constants/image_strings.dart';
import '../../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../../../../utils/utils.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../models/statistics/themkhachhang_model.dart';

class ThemKhachHangScreen extends StatefulWidget {
  const ThemKhachHangScreen({super.key});

  @override
  State<ThemKhachHangScreen> createState() => _ThemKhachHangScreenState();
}

class _ThemKhachHangScreenState extends State<ThemKhachHangScreen>
    with InputValidationMixin {
  String dropdownvalue = "Khách hàng";
  final controllerForm = Get.put(KhachHangController());
  final controllerCreate = Get.put(KhachHangRepository());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(tThemkhachhang,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: whiteColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage(addPartnerImage),
                    height: 200,
                  ),
                  const SizedBox(height: 30),
                  //Ten khach hang
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      labelText: "Tên khách hàng",
                      hintText: "Nhập tên",
                      errorStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(),
                    ),
                    controller: controllerForm.tenKhachHangController,
                    validator: (value) {
                      return oneCharacter(value!);
                    },
                  ),
                  const SizedBox(height: 15),
                  //So dien thoai
                  TextFormField(
                    controller: controllerForm.sDTKhachHangController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_iphone),
                        labelText: "Số điện thoại",
                        hintText: "Nhập SDT",
                        errorStyle: TextStyle(fontSize: 15),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  //Dia chi
                  TextFormField(
                    controller: controllerForm.diaChiKhachHangController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        labelText: "Địa chỉ",
                        hintText: "Nhập địa chỉ",
                        errorStyle: TextStyle(fontSize: 15),
                        border: OutlineInputBorder()),
                  ),

                  //Loai
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          children: [
                            Text("Loại", style: TextStyle(fontSize: 17))
                          ],
                        ),
                        Column(
                          children: [
                            DropdownButton<String>(
                              value: dropdownvalue,
                              icon: const Icon(Icons.expand_more),
                              style: const TextStyle(color: darkColor),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                    value: "Khách hàng",
                                    child: Text("Khách hàng",
                                        style: TextStyle(fontSize: 17))),
                                DropdownMenuItem(
                                    value: "Nhà cung cấp",
                                    child: Text("Nhà cung cấp",
                                        style: TextStyle(fontSize: 17))),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final maKH = generateKHCode();
                            final khachhang = ThemKhachHangModel(
                                tenkhachhang:
                                    controllerForm.tenKhachHangController.text,
                                sdt: controllerForm.sDTKhachHangController.text,
                                diachi: controllerForm
                                    .diaChiKhachHangController.text,
                                loai: dropdownvalue,
                                maKH: maKH);
                            controllerCreate.createKhachHangMoi(
                              khachhang,
                              controllerForm.tenKhachHangController.text,
                              maKH,
                            );
                            controllerForm.tenKhachHangController.clear();
                            controllerForm.sDTKhachHangController.clear();
                            controllerForm.diaChiKhachHangController.clear();
                          }
                        },
                        child: const Text(
                          "THÊM",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
