import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';
import '../../../statistics/kho/widget/card_kho_widget.dart';
import '../../../statistics/kho/widget/tabbar_hangtonkho_widget.dart';

class KhoShortCutScreen extends StatelessWidget {
  const KhoShortCutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kho",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: CardKhoWidget(),
              ),
              TabbarHangTonKhoWidget(),
              // HangTonKhoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
