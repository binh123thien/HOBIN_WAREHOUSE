import 'package:flutter/material.dart';

import '../../../../../../constants/color.dart';

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
  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        showCloseIcon: true,
        closeIconColor: whiteColor,
        backgroundColor: successColor,
        content: Text('Thêm thành công!'),
        duration: Duration(seconds: 2), // Thời gian hiển thị
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("2");
    return BottomAppBar(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 30) * 6 / 10,
                height: 45,
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
                          10), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: widget.isButtonEnabled
                      ? () {
                          setState(() {
                            widget.allThongTinItemNhap
                                .add(widget.thongTinItemNhap);
                            widget.setDefaulseThongTinNhapHang();
                            widget.checkFields();
                            _showSuccessSnackbar(context);
                          });
                        }
                      : null,
                  child: const Text(
                    'Thêm',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 30) * 4 / 10,
                height: 45,
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
                          10), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed:
                      widget.allThongTinItemNhap.isNotEmpty ? () {} : null,
                  child: widget.allThongTinItemNhap.isEmpty
                      ? const Text(
                          'Thanh toán',
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          'Thanh toán (${widget.allThongTinItemNhap.length})',
                          style: const TextStyle(fontSize: 18),
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
