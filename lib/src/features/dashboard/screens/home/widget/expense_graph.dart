import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../../common_widgets/fontSize/font_size.dart';
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
      final size = MediaQuery.of(context).size;
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: whiteColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "Doanh Thu Tuần",
                    style: TextStyle(fontSize: Font.sizes(context)[1]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors
                                .grey), // Màu viền và độ dày có thể được thay đổi
                        borderRadius:
                            BorderRadius.circular(5), // Bo góc viền ngoại
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
              width: size.width,
              height: size.height * 0.33,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkLiteColor),
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
                        Text(
                          "Doanh thu tuần này",
                          style: TextStyle(fontSize: Font.sizes(context)[0]),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          formatCurrency(selectedTongDoanhThu),
                          style: TextStyle(
                              fontSize: Font.sizes(context)[1],
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
