import 'package:flutter/material.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../statistics/sono/widget/card_sono_widget.dart';
import '../../../statistics/sono/widget/tabbar_sono_widget.dart';

class SoNoShortCutScreen extends StatefulWidget {
  const SoNoShortCutScreen({super.key});

  @override
  State<SoNoShortCutScreen> createState() => _SoNoShortCutScreenState();
}

class _SoNoShortCutScreenState extends State<SoNoShortCutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sổ nợ",
            style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: Font.sizes(context)[2])),
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
