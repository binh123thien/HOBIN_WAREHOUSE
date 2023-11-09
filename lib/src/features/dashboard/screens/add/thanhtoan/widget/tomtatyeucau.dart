import 'package:flutter/widgets.dart';

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
          const Row(
            children: [
              Text("Tóm tắt yêu cầu", style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Số lượng", style: TextStyle(fontSize: 16)),
              Text(widget.totalQuantity.toString(),
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tổng tiền", style: TextStyle(fontSize: 16)),
              Text(formatCurrency(widget.totalPrice),
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Giảm giá", style: TextStyle(fontSize: 16)),
              Text(formatCurrency(widget.giamgia),
                  style: const TextStyle(fontSize: 16, color: cancelColor)),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nợ", style: TextStyle(fontSize: 16)),
              Text(formatCurrency(widget.no),
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tổng", style: TextStyle(fontSize: 18)),
              Text(formatCurrency(widget.tong),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
