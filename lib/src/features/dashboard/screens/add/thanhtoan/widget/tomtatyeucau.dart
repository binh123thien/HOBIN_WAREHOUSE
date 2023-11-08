import 'package:flutter/widgets.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../utils/utils.dart';

class TomTatYeuCauWidget extends StatefulWidget {
  final num totalQuantity;
  final num totalPrice;
  final num giamgia;
  final num no;
  final num tong;
  const TomTatYeuCauWidget(
      {super.key,
      required this.totalQuantity,
      required this.totalPrice,
      required this.giamgia,
      required this.no,
      required this.tong});

  @override
  State<TomTatYeuCauWidget> createState() => _TomTatYeuCauWidgetState();
}

class _TomTatYeuCauWidgetState extends State<TomTatYeuCauWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text("Tóm tắt yêu cầu",
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số lượng",
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
              Text(widget.totalQuantity.toString(),
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tổng tiền",
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
              Text(formatCurrency(widget.totalPrice),
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Giảm giá",
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
              Text(formatCurrency(widget.giamgia),
                  style: TextStyle(
                      fontSize: Font.sizes(context)[1], color: cancelColor)),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nợ", style: TextStyle(fontSize: Font.sizes(context)[1])),
              Text(formatCurrency(widget.no),
                  style: TextStyle(fontSize: Font.sizes(context)[1])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tổng", style: TextStyle(fontSize: Font.sizes(context)[2])),
              Text(formatCurrency(widget.tong),
                  style: TextStyle(
                      fontSize: Font.sizes(context)[2],
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
