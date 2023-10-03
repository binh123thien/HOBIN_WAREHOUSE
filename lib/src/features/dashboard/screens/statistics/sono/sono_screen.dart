import 'package:flutter/material.dart';
import 'widget/card_sono_widget.dart';

import 'widget/tabbar_sono_widget.dart';

class SoNoScreen extends StatefulWidget {
  const SoNoScreen({super.key});

  @override
  State<SoNoScreen> createState() => _SoNoScreenState();
}

class _SoNoScreenState extends State<SoNoScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CardSoNoWidget(),
            ),
            TabbarSoNoWidget(),
          ],
        ),
      ),
    );
  }
}
