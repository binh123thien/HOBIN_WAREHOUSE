import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../controllers/statistics/doanhthu_controller.dart';
import 'chartScreen.dart';

class ExpenseTrack extends StatefulWidget {
  const ExpenseTrack({super.key});

  @override
  State<ExpenseTrack> createState() => _ExpenseTrackState();
}

class _ExpenseTrackState extends State<ExpenseTrack> {
  final dropdownValue = RxString('Đang tải...');
  var selectedWeek = '';
  num selectedTongDoanhThu = 10.0;

  @override
  Widget build(BuildContext context) {
    final DoanhThuController doanhThuControllerRepo = Get.find();
    return Obx(() {
      if (doanhThuControllerRepo.docDoanhThuTuanChart.isNotEmpty &&
          dropdownValue.value == "Đang tải...") {
        dropdownValue.value =
            doanhThuControllerRepo.docDoanhThuTuanChart[0]["datetime"];
        selectedWeek = doanhThuControllerRepo.docDoanhThuTuanChart[0]["week"];
        selectedTongDoanhThu =
            doanhThuControllerRepo.docDoanhThuTuanChart[0]["doanhthu"];
      }

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: whiteColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    "Doanh Thu Tuần",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors
                                .grey), // Màu viền và độ dày có thể được thay đổi
                        borderRadius:
                            BorderRadius.circular(4), // Bo góc viền ngoại
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: DropdownButton<dynamic>(
                          value: dropdownValue.value,
                          items: doanhThuControllerRepo.docDoanhThuTuanChart
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            String datetime = value["datetime"];
                            return DropdownMenuItem(
                              value: datetime,
                              child: Text(datetime),
                            );
                          }).toList(),
                          onChanged: (dynamic newValue) {
                            setState(() {
                              dropdownValue.value = newValue!;
                              selectedWeek = doanhThuControllerRepo
                                  .docDoanhThuTuanChart
                                  .firstWhere((item) =>
                                      item["datetime"] ==
                                      dropdownValue.value)["week"];
                              selectedTongDoanhThu = doanhThuControllerRepo
                                  .docDoanhThuTuanChart
                                  .firstWhere((item) =>
                                      item["datetime"] ==
                                      dropdownValue.value)["doanhthu"];
                            });
                          },
                          underline:
                              Container(), // Loại bỏ gạch chân mặc định của DropdownButton
                          icon: const Icon(
                              Icons.arrow_drop_down), // Icon mũi tên xuống),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 310,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Doanh Thu",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          formatCurrency(selectedTongDoanhThu),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ChartScreen(selectedWeek: selectedWeek),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
