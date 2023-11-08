import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';

class GiamGiaVaNoWidget extends StatefulWidget {
  final num giamgia;
  final num no;
  final Function giamgiaFunction;
  final Function noFunction;
  const GiamGiaVaNoWidget(
      {super.key,
      required this.giamgia,
      required this.no,
      required this.giamgiaFunction,
      required this.noFunction});

  @override
  State<GiamGiaVaNoWidget> createState() => _GiamGiaVaNoWidgetState();
}

class _GiamGiaVaNoWidgetState extends State<GiamGiaVaNoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.giamgiaFunction();
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(image: AssetImage(disCountIcon)),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Giảm giá",
                      style: TextStyle(fontSize: Font.sizes(context)[1]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    widget.giamgia != 0
                        ? Text(
                            "-${formatCurrency(widget.giamgia)}",
                            style: TextStyle(
                                fontSize: Font.sizes(context)[1],
                                color: cancelColor),
                          )
                        : const SizedBox(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: PhanCachWidget.dotLine(context),
        ),
        InkWell(
          onTap: () {
            widget.noFunction();
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(
                        image: AssetImage(noIcon),
                        color: successColor,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Nợ",
                      style: TextStyle(fontSize: Font.sizes(context)[1]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    widget.no != 0
                        ? Text(
                            formatCurrency(widget.no),
                            style: TextStyle(
                                fontSize: Font.sizes(context)[1],
                                color: successColor),
                          )
                        : const SizedBox(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
