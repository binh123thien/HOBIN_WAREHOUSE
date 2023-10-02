import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/thanhtoan/thanhtoan_xuathang_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../repository/add_repository/xuathang/xuathang_repository.dart';
import '../../../../controllers/add/chonhanghoa_controller.dart';

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
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  num existingSoluong = 0;
  bool _isLoading = false;
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
                            _isLoading = true; // Kích hoạt hiệu ứng loading
                          });
                          _themProcessing().then(
                            (_) {
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          );
                        }
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : const Text(
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

  Future<void> _themProcessing() async {
    try {
      for (int i = 0; i < widget.allThongTinItemXuat.length; i++) {
        if (widget.allThongTinItemXuat[i]["macode"] ==
            widget.thongTinItemXuat["macode"]) {
          existingSoluong = widget.allThongTinItemXuat[i]["soluong"];
          // Cập nhật lại soluong
          widget.thongTinItemXuat["soluong"] += existingSoluong;
          // Xóa bản ghi trùng
          widget.allThongTinItemXuat.removeAt(i);

          break; // Dừng vòng lặp khi đã xử lý
        }
      }
      controllerRepo
          .createListLocation(
              widget.thongTinItemXuat, widget.thongTinItemXuat["soluong"])
          .then((result) {
        setState(() {
          widget.thongTinItemXuat["locationAndexp"] = result;
          widget.allThongTinItemXuat.add(widget.thongTinItemXuat);
          for (var doc in controllerAllHangHoa.allHangHoaFireBase) {
            if (doc["macode"] == widget.thongTinItemXuat["macode"]) {
              doc["tonkho"] = doc["tonkho"] -
                  widget.thongTinItemXuat["soluong"] +
                  existingSoluong;
              break; // Dừng vòng lặp khi đã tìm và cập nhật giá trị
            }
          }

          widget.setDefaulseThongTinXuatHang();
          widget.checkFields();
          widget.changeStateBlockSoluong();
          SnackBarWidget.showSnackBar(
              context, "Thêm thành công!", successColor);
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
