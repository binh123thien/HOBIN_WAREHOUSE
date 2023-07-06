import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';

class DonePhanPhoiScreen extends StatefulWidget {
  const DonePhanPhoiScreen({super.key});

  @override
  State<DonePhanPhoiScreen> createState() => _DonePhanPhoiScreenState();
}

class _DonePhanPhoiScreenState extends State<DonePhanPhoiScreen> {
  @override
  Widget build(BuildContext context) {
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
      backgroundColor: backGroundDefaultFigma,
      body: SizedBox(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(successIcon),
                  height: 35,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  'Phân phối hàng hóa thành công!',
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
