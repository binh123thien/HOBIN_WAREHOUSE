import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../utils/utils.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.arrayList,
  });

  final List arrayList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Wrap(
      spacing: 20,
      children: List.generate(arrayList.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Container(
            width: (size.width - 50) / 2,
            height: 65,
            decoration: BoxDecoration(
                color: backGroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: darkColor.withOpacity(0.1))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image(image: arrayList[index]["icon"]),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      arrayList[index]["title"],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w100),
                    ),
                  ]),
                  Text(
                    index == 0
                        ? arrayList[index]["value"].toString()
                        : formatCurrency(arrayList[index]["value"]),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
