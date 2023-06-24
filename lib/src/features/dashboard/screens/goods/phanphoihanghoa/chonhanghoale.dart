import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';

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
    final donvi = updatehanghoaSi['donvi'];
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
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(distributeGoodIcon),
                          height: 35,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${donvi.substring(0, 2).toUpperCase()}${donvi.substring(1)} '),
                                Text(updatehanghoaSi['tensanpham'])
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Tồn kho: ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(updatehanghoaSi['tonkho'].toString(),
                                    style: TextStyle(fontSize: 15)),
                                Text(' $donvi', style: TextStyle(fontSize: 15)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.east_outlined,
              ),
              Container(
                child: Row(
                  children: [
                    Image(
                      image: AssetImage(distributeGoodIcon),
                      height: 30,
                    ),
                    Text(updatehanghoaLe['donvi']),
                    Text(updatehanghoaLe['tensanpham'])
                  ],
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
