import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/kho/widget/card_kho_widget.dart';
import 'widget/tabbar_hangtonkho_widget.dart';

class KhoScreen extends StatefulWidget {
  const KhoScreen({super.key});

  @override
  State<KhoScreen> createState() => _KhoScreenState();
}

class _KhoScreenState extends State<KhoScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
