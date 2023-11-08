import 'package:flutter/material.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';

class PhuongThucThanhToanWidget extends StatefulWidget {
  final String selectedPaymentMethod;
  final Function(String) reload;
  const PhuongThucThanhToanWidget(
      {super.key, required this.selectedPaymentMethod, required this.reload});

  @override
  State<PhuongThucThanhToanWidget> createState() =>
      _PhuongThucThanhToanWidgetState();
}

class _PhuongThucThanhToanWidgetState extends State<PhuongThucThanhToanWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Text(
                "Phương thức thanh toán",
                style: TextStyle(fontSize: Font.sizes(context)[1]),
              ),
            ],
          ),
        ),
        buildRadioTile("Tiền mặt", tienMatIcon),
        buildRadioTile("Chuyển khoản", chuyenKhoangIcon),
        buildRadioTile("Ví điện tử", viDienTuIcon),
      ],
    );
  }

  Widget buildRadioTile(String value, String assetName) {
    return InkWell(
      onTap: () {
        widget.reload(value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                SizedBox(
                    height: 18,
                    width: 18,
                    child: Image(image: AssetImage(assetName))),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: Font.sizes(context)[1]),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Radio(
              value: value,
              groupValue: widget.selectedPaymentMethod,
              onChanged: (newValue) {
                widget.reload(newValue!);
              },
              activeColor: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
