import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/thanhtoan/thanhtoan_xuathang_screen.dart';
import 'package:page_transition/page_transition.dart';

class BottomBarXuatHang extends StatefulWidget {
  final bool isButtonEnabled;
  final VoidCallback checkFields;
  final VoidCallback setDefaulseThongTinXuatHang;
  final List<Map<String, dynamic>> allThongTinItemXuat;
  final Map<String, dynamic> thongTinItemXuat;
  const BottomBarXuatHang(
      {super.key,
      required this.isButtonEnabled,
      required this.checkFields,
      required this.setDefaulseThongTinXuatHang,
      required this.allThongTinItemXuat,
      required this.thongTinItemXuat});

  @override
  State<BottomBarXuatHang> createState() => _BottomBarXuatHangState();
}

class _BottomBarXuatHangState extends State<BottomBarXuatHang> {
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
                    backgroundColor: mainColor,
                    side: BorderSide(
                        color: widget.isButtonEnabled
                            ? mainColor
                            : Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: widget.isButtonEnabled
                      ? () {
                          setState(() {
                            widget.allThongTinItemXuat
                                .add(widget.thongTinItemXuat);
                            widget.setDefaulseThongTinXuatHang();
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
                    backgroundColor: mainColor,
                    side: BorderSide(
                        color: widget.isButtonEnabled
                            ? mainColor
                            : Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: widget.allThongTinItemXuat.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ThanhToanXuatHangScreen(
                                  allThongTinItemXuat:
                                      widget.allThongTinItemXuat,
                                )),
                          );
                        }
                      : null,
                  child: widget.allThongTinItemXuat.isEmpty
                      ? const Text(
                          'Thanh toán',
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          'Thanh toán (${widget.allThongTinItemXuat.length})',
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
