import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
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
                const Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(image: AssetImage(disCountIcon)),
                    ),
                    SizedBox(width: 7),
                    Text(
                      "Giảm giá",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    widget.giamgia != 0
                        ? Text(
                            "-${formatCurrency(widget.giamgia)}",
                            style: const TextStyle(
                                fontSize: 16, color: cancelColor),
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
                const Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(
                        image: AssetImage(noIcon),
                        color: successColor,
                      ),
                    ),
                    SizedBox(width: 7),
                    Text(
                      "Nợ",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    widget.no != 0
                        ? Text(
                            formatCurrency(widget.no),
                            style: const TextStyle(
                                fontSize: 16, color: successColor),
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
