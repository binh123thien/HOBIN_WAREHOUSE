import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

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
            width: (size.width - 60) / 2,
            height: 85,
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    SizedBox(
                      width: 35,
                      height: 35,
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
                    arrayList[index]["value"],
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
