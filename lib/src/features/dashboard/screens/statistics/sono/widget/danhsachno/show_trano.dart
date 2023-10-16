import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/history_repository/history_repository.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../repository/history_repository/lichsutrano_repository.dart';
import '../../../../../../../repository/statistics_repository/no_repository.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../utils/validate/formsoluong.dart';
import '../../../../../../../utils/validate/validate.dart';
import '../../../../../models/statistics/lichsutrano_model.dart';

class ShowTraNo extends StatefulWidget {
  final num tongno;
  final String billType;
  final String tenkhachhang;
  final FocusNode focusNode;
  const ShowTraNo(
      {super.key,
      required this.tongno,
      required this.billType,
      required this.tenkhachhang,
      required this.focusNode});

  @override
  State<ShowTraNo> createState() => _ShowTraNoState();
}

class _ShowTraNoState extends State<ShowTraNo> {
  final controllerLSRepo = Get.put(LichSuTraNoRepository());
  final controllerHistory = Get.put(HistoryRepository());
  final controllerNoRepo = Get.put(NoRepository());
  num trano = 0;
  bool hasError = false;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSaveButtonPressed() async {
    try {
      trano = num.tryParse(_controller.value.text) ?? 0;
      // Lấy danh sách các documents trong collection NhapHang hoặc BanHang
      final alldonhang = await controllerHistory.loadAllDonXuatHangHoacNhapHang(
          widget.billType == "XuatHang" ? "XuatHang" : "NhapHang");
      final listNo = alldonhang.docs
          .where(
            (doc) => doc['khachhang'] == widget.tenkhachhang && doc['no'] > 0,
          )
          .toList();
      final sortedListNo = List.from(listNo)
        ..sort((a, b) => a['soHD'].compareTo(b['soHD']));
      //su dung bien tam de tru tien no, neu khong su dung lich su tra no se sai
      num tranotam = trano;
      for (final doc in sortedListNo) {
        final no = doc['no'];
        final docRef = doc.reference;

        if (tranotam >= no) {
          tranotam -= no;
          await docRef.update({
            'no': 0,
            'tongthanhtoan': FieldValue.increment(no),
            'trangthai': 'Thành công'
          });
          if (widget.billType == "XuatHang") {
            final ngay = doc["datetime"];
            controllerNoRepo.updateTrangThaiNgaySauKhiTraNo(
                ngay, no, "traNoLonHonNo");
            controllerNoRepo.updateTrangThaiTuanSauKhiTraNo(
                ngay, no, "traNoLonHonNo");
            controllerNoRepo.updateTrangThaiThangSauKhiTraNo(
                ngay, no, "traNoLonHonNo");
          }
        } else {
          await docRef.update({
            'no': no - tranotam,
            'tongthanhtoan': FieldValue.increment(tranotam),
          });
          if (widget.billType == "XuatHang") {
            final ngay = doc["datetime"];
            controllerNoRepo.updateTrangThaiNgaySauKhiTraNo(
                ngay, tranotam, "traNoNhoHonNo");
            controllerNoRepo.updateTrangThaiTuanSauKhiTraNo(
                ngay, tranotam, "traNoNhoHonNo");
            controllerNoRepo.updateTrangThaiThangSauKhiTraNo(
                ngay, tranotam, "traNoNhoHonNo");
            break;
          }
        }
      }
      final ngaytao = formatNgayTao();
      final soHD = generateLSNCode();
      final lichsutrano = LichSuTraNoModel(
        billType: widget.billType == "XuatHang" ? "XuatHang" : "NhapHang",
        khachhang: widget.tenkhachhang,
        ngaytrano: ngaytao,
        soHD: soHD,
        nocu: widget.tongno,
        sotientra: trano,
        conno: widget.tongno - trano,
      );
      controllerLSRepo.createLichSuTraNo(lichsutrano, soHD);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.19,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Nhập số tiền trả",
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: hasError ? 66 : 40,
                      width: (MediaQuery.of(context).size.width - 30) * 7 / 10,
                      child: TextFormField(
                        focusNode: widget.focusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _controller,
                        validator: (value) {
                          return nonZeroInput(value);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaxValueTextInputFormatter(widget.tongno)
                        ],
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: blueColor, width: 2),
                            borderRadius: BorderRadius.zero,
                          ),
                          hintText: 'Nhập giá trị',
                        ),
                      ),
                    ),
                    SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - 30) * 2.9 / 10,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: blueColor,
                          side: BorderSide(
                              color: _controller.text.isNotEmpty
                                  ? blueColor
                                  : Colors.grey[500]!),
                        ),
                        onPressed: _controller.text.isNotEmpty
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _onSaveButtonPressed().then((value) {
                                    Navigator.of(context).pop(_controller.text);
                                  });
                                } else {
                                  setState(() {
                                    hasError = true; // Đặt trạng thái lỗi
                                  });
                                }
                              }
                            : null,
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
