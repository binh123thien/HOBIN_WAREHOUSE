import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../thanhtoan/thanhtoan_nhaphang_screen.dart';

class BottomBarNhapHang extends StatefulWidget {
  final bool isButtonEnabled;
  final VoidCallback checkFields;
  final VoidCallback setDefaulseThongTinNhapHang;
  final List<Map<String, dynamic>> allThongTinItemNhap;
  final Map<String, dynamic> thongTinItemNhap;
  const BottomBarNhapHang(
      {super.key,
      required this.isButtonEnabled,
      required this.checkFields,
      required this.allThongTinItemNhap,
      required this.thongTinItemNhap,
      required this.setDefaulseThongTinNhapHang});

  @override
  State<BottomBarNhapHang> createState() => _BottomBarNhapHangState();
}

class _BottomBarNhapHangState extends State<BottomBarNhapHang> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      height: size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: (size.width - 30) * 6 / 10,
                height: size.height * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: blueColor,
                    side: BorderSide(
                        color: widget.isButtonEnabled
                            ? blueColor
                            : Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: widget.isButtonEnabled
                      ? () {
                          setState(() {
                            widget.allThongTinItemNhap
                                .add(widget.thongTinItemNhap);
                            widget.setDefaulseThongTinNhapHang();
                            widget.checkFields();
                            SnackBarWidget.showSnackBar(
                                context, "Thêm thành công", successColor);
                          });
                        }
                      : null,
                  child: Text(
                    'Thêm',
                    style: TextStyle(fontSize: Font.sizes(context)[2]),
                  ),
                ),
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: (size.width - 30) * 4 / 10,
                height: size.height * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: blueColor,
                    side: BorderSide(
                        color: widget.isButtonEnabled
                            ? blueColor
                            : Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: widget.allThongTinItemNhap.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ThanhToanScreen(
                                  allThongTinItemNhap:
                                      widget.allThongTinItemNhap,
                                )),
                          );
                        }
                      : null,
                  child: widget.allThongTinItemNhap.isEmpty
                      ? Text(
                          'Thanh toán',
                          style: TextStyle(fontSize: Font.sizes(context)[2]),
                        )
                      : Text(
                          'Thanh toán (${widget.allThongTinItemNhap.length})',
                          style: TextStyle(fontSize: Font.sizes(context)[2]),
                        ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
