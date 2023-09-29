import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../constants/color.dart';

class PhanCachWidget {
  static Widget dotLine(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: MediaQuery.of(context).size.width,
      lineThickness: 1,
      dashLength: 8.0,
      dashColor: const Color.fromARGB(255, 209, 209, 209),
      dashGapLength: 6.0,
      dashGapColor: Colors.transparent,
    );
  }

  static Widget space() {
    return Container(
      height: 10,
      color: greyColor,
    );
  }
}
