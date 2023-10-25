import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../common_widgets/dotline/dotline.dart';
import '../../../../common_widgets/fontSize/font_size.dart';
import '../../../../utils/utils.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.arrayList,
    required this.height,
  });
  final double height;
  final List arrayList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: darkLiteColor),
          borderRadius: BorderRadius.circular(10),
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
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[0]),
                            ),
                          ],
                        ),
                        Text(
                          index == 0
                              ? arrayList[index]["value"].toString()
                              : formatCurrency(arrayList[index]["value"]),
                          style: TextStyle(fontSize: Font.sizes(context)[0]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    index != arrayList.length - 1
                        ? PhanCachWidget.dotLine(context)
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
