import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:intl/intl.dart';

import '../../../../../../constants/color.dart';
import '../../../../controllers/home/hethan_controller.dart';

class HetHanShortcutScreen extends StatefulWidget {
  const HetHanShortcutScreen({super.key});

  @override
  State<HetHanShortcutScreen> createState() => _HetHanShortcutScreenState();
}

class _HetHanShortcutScreenState extends State<HetHanShortcutScreen> {
  final controllerHetHan = Get.put(HetHanController());
  List<Map<String, dynamic>> dataHetHan = [];
  bool? isChecked = false;
  DateTime? startDate;
  DateTime? endDate;
  String startDateFormated = "";
  String endDateFormated = "";
  void _onTap() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: mainColor, // Set the background color here
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        startDate = pickedDateRange.start;
        startDateFormated = formatDate(startDate!);
        endDate = pickedDateRange.end;
        endDateFormated = formatDate(endDate!);
      });
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("Hết Hạn",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _onTap,
                        child: Container(
                          width: 230,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: darkColor),
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                const Image(
                                  image: AssetImage(lichIcon),
                                  height: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  startDate != null && endDate != null
                                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                      : 'Chọn ngày...',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            controllerHetHan
                                .getFilteredData(
                                    startDateFormated, endDateFormated)
                                .then((value) {
                              setState(() {
                                dataHetHan = value;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: mainColor,
                            side: const BorderSide(color: mainColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  7), // giá trị này xác định bán kính bo tròn
                            ),
                          ),
                          child: const Text(
                            'Tìm kiếm',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Container(
          child: ListView.builder(
              itemCount: dataHetHan.length,
              itemBuilder: (context, index) {
                final docdata = dataHetHan[index];
                return Column(
                  children: [
                    CheckboxListTile(
                      title:
                          Text("${docdata["tensanpham"]} - ${docdata["gia"]}"),
                      value: isChecked,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          isChecked = newvalue;
                        });
                      },
                      activeColor: mainColor,
                      tileColor: whiteColor,
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${docdata["exp"]} - SL: ${docdata["soluong"]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${docdata["location"]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1,
                      dashLength: 8.0,
                      dashColor: Color.fromARGB(255, 209, 209, 209),
                      dashGapLength: 6.0,
                      dashGapColor: Colors.transparent,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
