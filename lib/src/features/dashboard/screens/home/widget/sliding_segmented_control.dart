import 'package:flutter/cupertino.dart';

class SlidingSegmentedControl extends StatefulWidget {
  const SlidingSegmentedControl({super.key});

  @override
  State<SlidingSegmentedControl> createState() =>
      _SlidingSegmentedControlState();
}

class _SlidingSegmentedControlState extends State<SlidingSegmentedControl> {
  int? _sliding = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      children: const {
        0: Text("Ngày", style: TextStyle(fontSize: 15)),
        1: Text("Tháng", style: TextStyle(fontSize: 15)),
      },
      groupValue: _sliding,
      onValueChanged: (int? newValue) {
        setState(() {
          _sliding = newValue;
        });
      },
    );
  }
}
