import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';

class CardNhapHangShowMore extends StatefulWidget {
  final dynamic hanghoa;
  const CardNhapHangShowMore({super.key, this.hanghoa});

  @override
  State<CardNhapHangShowMore> createState() => _CardNhapHangShowMoreState();
}

class _CardNhapHangShowMoreState extends State<CardNhapHangShowMore> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: whiteColor,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
          leading: widget.hanghoa["photoGood"].isEmpty
              ? const Image(
                  image: AssetImage(hanghoaIcon),
                  height: 35,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 40,
                    width: 40,
                    imageUrl: widget.hanghoa["photoGood"].toString(),
                    fit: BoxFit.fill,
                  ),
                ),
          title: Text(
            widget.hanghoa["tensanpham"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Bán: ${widget.hanghoa["daban"]} ${widget.hanghoa["donvi"]}",
              //   style:
              //       const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
              //   textAlign: TextAlign.start,
              // ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 65,
                height: 25,
                child: ElevatedButton(
                  onPressed: () {
                    MyDialog.showAlertDialogTextfield(
                        context, 'Thêm location', '', () {
                      String userInput = _textEditingController.text;
                      print('Giá trị nhập: $userInput');
                    }, _textEditingController);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: blueColor,
                    side: const BorderSide(color: blueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  child: const Text(
                    'Thêm',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            "Kho: ${widget.hanghoa["tonkho"]} ${widget.hanghoa["donvi"]} - ${formatCurrency(widget.hanghoa["giaban"])}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
            textAlign: TextAlign.start,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Chưa có location")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
