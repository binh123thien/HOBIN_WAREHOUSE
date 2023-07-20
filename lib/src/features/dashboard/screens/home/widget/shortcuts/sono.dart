import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';
import '../../../statistics/sono/widget/card_sono_widget.dart';
import '../../../statistics/sono/widget/tabbar_sono_widget.dart';

class SoNoShortCutScreen extends StatelessWidget {
  const SoNoShortCutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sổ nợ",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: CardSoNoWidget(),
              ),
              TabbarSoNoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
