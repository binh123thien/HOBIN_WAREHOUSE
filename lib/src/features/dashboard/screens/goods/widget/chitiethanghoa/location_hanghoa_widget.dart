import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../add/nhaphang/widget/location_widget.dart';

class LocationHangHoaWidget extends StatefulWidget {
  const LocationHangHoaWidget({
    super.key,
    required this.hanghoa,
  });
  final dynamic hanghoa;

  @override
  State<LocationHangHoaWidget> createState() => _LocationHangHoaWidgetState();
}

class _LocationHangHoaWidgetState extends State<LocationHangHoaWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: mainColor,
            ),
            height: 35,
            width: size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 7, 12, 5),
              child: Text(
                "Vị trí",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
            ),
          ),
          Container(
            width: size.width - 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: mainColor),
              color: whiteColor,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LocationWidget(hanghoa: widget.hanghoa),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
