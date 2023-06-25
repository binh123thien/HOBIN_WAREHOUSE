import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/widget/cardphanphoihang_widget.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/validate/validate.dart';

class ChonHangHoaLeScreen extends StatefulWidget {
  final dynamic hanghoaLe;
  final dynamic hanghoaSi;
  const ChonHangHoaLeScreen({super.key, this.hanghoaLe, this.hanghoaSi});

  @override
  State<ChonHangHoaLeScreen> createState() => _ChonHangHoaLeScreenState();
}

class _ChonHangHoaLeScreenState extends State<ChonHangHoaLeScreen> {
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
    final size = MediaQuery.of(context).size;
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
            icon: Icon(Icons.done, size: 30, color: darkColor),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: backGroundDefaultFigma,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CardPhanPhoiHang(
                  imageProduct: distributeGoodIcon,
                  donViProduct: updatehanghoaSi['donvi'],
                  updatehanghoa: updatehanghoaSi),
              const Icon(
                Icons.east_outlined,
              ),
              CardPhanPhoiHang(
                  imageProduct: distributeGoodIcon,
                  donViProduct: updatehanghoaLe['donvi'],
                  updatehanghoa: updatehanghoaLe),
            ]),
            Container(
              width: size.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
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
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          '1 ${updatehanghoaSi['donvi'].substring(0, 1).toUpperCase()}${updatehanghoaSi['donvi'].substring(1)}'),
                      const Text(' = '),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: TextFormField(
                          // controller: controller.email,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(fontSize: 15),
                              border: OutlineInputBorder()),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            return nonZeroInput(value!);
                          },
                        ),
                      ),
                      Text(' ${updatehanghoaLe['donvi']}')
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: size.width,
              height: 120,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(10),
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
                    SizedBox(
                      height: 30,
                      width: 300,
                      child: TextFormField(
                        // controller: controller.email,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 15),
                            border: OutlineInputBorder()),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          return nonZeroInput(value!);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
