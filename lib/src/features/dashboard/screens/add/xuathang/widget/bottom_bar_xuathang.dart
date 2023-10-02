import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/thanhtoan/thanhtoan_xuathang_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../repository/add_repository/xuathang/xuathang_repository.dart';

class BottomBarXuatHang extends StatefulWidget {
  final bool isButtonEnabled;
  final VoidCallback checkFields;
  final VoidCallback changeStateBlockSoluong;
  final VoidCallback setDefaulseThongTinXuatHang;
  final List<Map<String, dynamic>> allThongTinItemXuat;
  final Map<String, dynamic> thongTinItemXuat;
  const BottomBarXuatHang(
      {super.key,
      required this.isButtonEnabled,
      required this.setDefaulseThongTinXuatHang,
      required this.allThongTinItemXuat,
      required this.thongTinItemXuat,
      required this.checkFields,
      required this.changeStateBlockSoluong});

  @override
  State<BottomBarXuatHang> createState() => _BottomBarXuatHangState();
}

class _BottomBarXuatHangState extends State<BottomBarXuatHang> {
  final controllerRepo = Get.put(XuatHangRepository());

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
                          controllerRepo
                              .createListLocation(widget.thongTinItemXuat,
                                  widget.thongTinItemXuat["soluong"])
                              .then((result) {
                            setState(() {
                              widget.thongTinItemXuat["locationAndexp"] =
                                  result;
                              widget.allThongTinItemXuat
                                  .add(widget.thongTinItemXuat);
                              widget.setDefaulseThongTinXuatHang();
                              widget.checkFields();
                              widget.changeStateBlockSoluong();
                              SnackBarWidget.showSnackBar(
                                  context, "Thêm thành công!", successColor);
                            });
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
                        color: widget.allThongTinItemXuat.isNotEmpty
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
