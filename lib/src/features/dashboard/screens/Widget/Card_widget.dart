import 'package:dotted_line/dotted_line.dart';
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
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: arrayList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Image(image: arrayList[index]["icon"]),
                            ),
                            const SizedBox(width: 9),
                            Text(
                              arrayList[index]["title"],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                        Text(
                          index == 0
                              ? arrayList[index]["value"].toString()
                              : formatCurrency(arrayList[index]["value"]),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    index != arrayList.length - 1
                        ? const DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1,
                            dashLength: 8.0,
                            dashColor: Color.fromARGB(255, 209, 209, 209),
                            dashGapLength: 6.0,
                            dashGapColor: Colors.transparent,
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
