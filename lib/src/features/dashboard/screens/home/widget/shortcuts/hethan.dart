import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';

class HetHanShortcutScreen extends StatefulWidget {
  const HetHanShortcutScreen({super.key});

  @override
  State<HetHanShortcutScreen> createState() => _HetHanShortcutScreenState();
}

class _HetHanShortcutScreenState extends State<HetHanShortcutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hết Hạn",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
    );
  }
}
