import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/widget/cardphanphoihang_widget.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/validate/validate.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import 'donephanphoi.dart';

class ChonHangHoaLeScreen extends StatefulWidget {
  final dynamic hanghoaLe;
  final dynamic hanghoaSi;
  const ChonHangHoaLeScreen({super.key, this.hanghoaLe, this.hanghoaSi});

  @override
  State<ChonHangHoaLeScreen> createState() => _ChonHangHoaLeScreenState();
}

class _ChonHangHoaLeScreenState extends State<ChonHangHoaLeScreen>
    with InputValidationMixin {
  final controllerHangHoa = Get.put(ChonHangHoaLeController());
  late dynamic updatehanghoaSi;
  late dynamic updatehanghoaLe;

  @override
  void initState() {
    updatehanghoaSi = widget.hanghoaSi;
    updatehanghoaLe = widget.hanghoaLe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done, size: 30, color: darkColor),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (updatehanghoaSi['tonkho'] <
                    int.tryParse(controllerHangHoa.soLuongSi.text)) {
                  Get.snackbar('Có lỗi xảy ra',
                      'Số lượng hàng cần chuyển đổi lớn hơn tồn kho');
                } else {
                  controllerHangHoa.calculate(
                      controllerHangHoa.soLuongLe.text,
                      controllerHangHoa.soLuongSi.text,
                      updatehanghoaSi,
                      updatehanghoaLe);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DonePhanPhoiScreen()),
                  );
                }
              }
              print('doneeeeeeeeeeee');
              print(controllerHangHoa.soLuongLe.text);
              print(controllerHangHoa.soLuongSi.text);
            },
          )
        ],
      ),
      backgroundColor: backGroundDefaultFigma,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CardPhanPhoiHang(
                    imageProduct: updatehanghoaSi['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : updatehanghoaSi['photoGood'],
                    donViProduct: updatehanghoaSi['donvi'],
                    updatehanghoa: updatehanghoaSi),
                const Icon(
                  Icons.east_outlined,
                ),
                CardPhanPhoiHang(
                    imageProduct: updatehanghoaLe['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : updatehanghoaLe['photoGood'],
                    donViProduct: updatehanghoaLe['donvi'],
                    updatehanghoa: updatehanghoaLe),
              ]),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(warningIcon),
                            height: 35,
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Expanded(
                            child: Text(
                              'Nhập chính xác số lượng đơn vị bán lẻ trên 1 đơn vị kiện hàng bán sỉ',
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1 ${updatehanghoaSi['donvi'].substring(0, 1).toUpperCase()}${updatehanghoaSi['donvi'].substring(1)}',
                          ),
                          const Text(' = '),
                          Expanded(
                            child: TextFormField(
                              controller: controllerHangHoa.soLuongLe,
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        10), // Khoảng cách giữa viền và nội dung
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                return nonZeroInput(value!);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d{0,6}')),
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(' ${updatehanghoaLe['donvi']}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 170,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(children: [
                        const Image(
                          image: AssetImage(warningIcon),
                          height: 35,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        Expanded(
                          child: Text(
                            'Nhập số lượng ${updatehanghoaSi['donvi']} cần chuyển đổi',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controllerHangHoa.soLuongSi,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            errorStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder()),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          return nonZeroInput(value!);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,6}')),
                        ],
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
