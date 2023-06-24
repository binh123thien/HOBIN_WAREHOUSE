import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/history_repository/history_repository.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../repository/history_repository/lichsutrano_repository.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../controllers/statistics/no_controlller.dart';
import '../../../../../models/statistics/lichsutrano_model.dart';
import '../../../../Widget/add/maxmin_input_textformfield.dart';

class ShowTraNo extends StatefulWidget {
  final num tongno;
  final String billType;
  final String tenkhachhang;
  const ShowTraNo(
      {super.key,
      required this.tongno,
      required this.billType,
      required this.tenkhachhang});

  @override
  State<ShowTraNo> createState() => _ShowTraNoState();
}

class _ShowTraNoState extends State<ShowTraNo> {
  final controllerLSRepo = Get.put(LichSuTraNoRepository());
  final controllerNo = Get.put(NoController());
  final controllerHistory = Get.put(HistoryRepository());
  num trano = 0;

  Future<void> _onSaveButtonPressed() async {
    try {
      trano = num.tryParse(controllerNo.traNoController.text) ?? 0;
      // Lấy danh sách các documents trong collection NhapHang hoặc BanHang

      final alldonhang = await controllerHistory.loadAllDonBanHangHoacNhapHang(
          widget.billType == "BanHang" ? "BanHang" : "NhapHang");
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
        } else {
          await docRef.update({
            'no': no - tranotam,
            'tongthanhtoan': FieldValue.increment(tranotam),
          });
          break;
        }
      }
      final ngaytao = formatNgaytao();
      final soHD = generateLSNCode();
      final lichsutrano = LichSuTraNoModel(
        billType: widget.billType == "BanHang" ? "BanHang" : "NhapHang",
        khachhang: widget.tenkhachhang,
        ngaytrano: ngaytao,
        soHD: soHD,
        nocu: widget.tongno,
        sotientra: trano,
        conno: widget.tongno - trano,
      );
      controllerLSRepo.createLichSuTraNo(lichsutrano, soHD);
      // ======================== Message=====================//
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Thành công!'),
      ));
      // Wait for a short time to let the user see the SnackBar
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => setState(() {
                controllerNo.traNoController.clear();
                Navigator.of(context).pop(trano);
              }));
    } catch (e) {
      print("Error: $e");
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print(widget.sumPrice);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: size.height * 0.285,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Trả tiền nợ", style: TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 120,
                width: size.width - 30,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerNo.traNoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        NumberFormatter(maxValue: (widget.tongno).round()),
                      ],
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nhập số cần trả'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                          height: 50,
                          width: size.width - 30,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: _onSaveButtonPressed,
                              child: const Text("Xong"))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
