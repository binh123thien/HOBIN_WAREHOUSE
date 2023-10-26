import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuts/hethan/xuatkhohethan.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../common_widgets/network/network.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../controllers/home/hethan_controller.dart';

class HetHanShortcutScreen extends StatefulWidget {
  const HetHanShortcutScreen({super.key});

  @override
  State<HetHanShortcutScreen> createState() => _HetHanShortcutScreenState();
}

class _HetHanShortcutScreenState extends State<HetHanShortcutScreen> {
  final controllerHetHan = Get.put(HetHanController());
  List<Map<String, dynamic>> dataHetHan = [];
  List<Map<String, dynamic>> selectedItemsHetHan = [];

  bool checkdataEmpty = false;
  bool? isChecked = false;
  bool selectAll = false;
  DateTime? startDate;
  DateTime? endDate;
  String startDateFormated = "";
  String endDateFormated = "";
  bool isloading = false;
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
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text("Hết Hạn",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
          backgroundColor: mainColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.07),
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
                            width: size.width * 0.65,
                            height: size.height * 0.047,
                            decoration: BoxDecoration(
                                border: Border.all(color: darkColor),
                                borderRadius: BorderRadius.circular(7)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage(lichIcon),
                                    height: size.height * 0.027,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    startDate != null && endDate != null
                                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                        : 'Chọn ngày...',
                                    style: TextStyle(
                                        fontSize: Font.sizes(context)[0]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: size.width * 0.25,
                          height: size.height * 0.047,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isloading = true;
                              });
                              controllerHetHan
                                  .getFilteredData(
                                      startDateFormated, endDateFormated)
                                  .then((value) {
                                setState(() {
                                  dataHetHan = value;
                                  isloading = false;
                                  if (value.isEmpty) {
                                    checkdataEmpty = true;
                                  } else {
                                    checkdataEmpty = false;
                                  }
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
                            child: Text(
                              'Tìm kiếm',
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
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
        body: isloading == false
            ? Padding(
                padding: const EdgeInsets.only(top: 7),
                child: checkdataEmpty == true
                    ? Center(
                        child: Text(
                        "Không có dữ liệu",
                        style: TextStyle(fontSize: Font.sizes(context)[2]),
                      ))
                    : Column(
                        children: [
                          dataHetHan.isNotEmpty
                              ? CheckboxListTile(
                                  title: Text("Chọn tất cả",
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[2])),
                                  value: selectAll,
                                  activeColor: mainColor,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectAll = newValue!;
                                      if (selectAll) {
                                        selectedItemsHetHan.clear();
                                        selectedItemsHetHan.addAll(dataHetHan);
                                      } else {
                                        selectedItemsHetHan.clear();
                                      }
                                    });
                                  },
                                )
                              : const SizedBox(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: dataHetHan.length,
                              itemBuilder: (context, index) {
                                final docdata = dataHetHan[index];
                                String dateString = docdata["exp"];
                                DateTime expirationDate =
                                    DateFormat('dd/MM/yyyy').parse(dateString);
                                DateTime currentDate = DateTime.now();
                                int daysRemaining = expirationDate
                                        .difference(currentDate)
                                        .inDays +
                                    1;
                                return Column(
                                  children: [
                                    CheckboxListTile(
                                      title: Text(
                                        "${docdata['tensanpham']} - ${formatCurrency(docdata['gia'])}",
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[1]),
                                      ),
                                      value:
                                          selectedItemsHetHan.contains(docdata),
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          if (newValue != null && newValue) {
                                            selectedItemsHetHan.add(docdata);
                                          } else {
                                            selectedItemsHetHan.remove(docdata);
                                          }
                                          if (selectedItemsHetHan.length ==
                                              dataHetHan.length) {
                                            selectAll = true;
                                          } else {
                                            selectAll = false;
                                          }
                                        });
                                      },
                                      activeColor: mainColor,
                                      subtitle: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runSpacing: 5,
                                        children: [
                                          Text(
                                            "${docdata["exp"]} - SL: ${docdata["soluong"]} - ${docdata["location"]}",
                                            style: TextStyle(
                                                fontSize:
                                                    Font.sizes(context)[0] *
                                                        0.95),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: daysRemaining > 1000
                                                ? size.width * 0.21
                                                : size.width * 0.18,
                                            height: size.height * 0.03,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: daysRemaining < 10
                                                        ? mainColor
                                                        : successColor),
                                                color: whiteColor),
                                            child: Center(
                                              child: currentDate
                                                      .isAfter(expirationDate)
                                                  ? Text(
                                                      "Hết hạn",
                                                      style: TextStyle(
                                                          fontSize: Font.sizes(
                                                              context)[0],
                                                          color: mainColor),
                                                    )
                                                  : Text(
                                                      "$daysRemaining ngày",
                                                      style: TextStyle(
                                                          fontSize: Font.sizes(
                                                              context)[0],
                                                          color: daysRemaining <
                                                                  10
                                                              ? mainColor
                                                              : successColor),
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    PhanCachWidget.dotLine(context),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ))
            : const Center(
                child: CircularProgressIndicator(),
              ),
        bottomNavigationBar: dataHetHan.isNotEmpty
            ? BottomAppBar(
                height: size.height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: size.width - 30,
                      height: size.height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: mainColor,
                          side: BorderSide(
                              color: selectedItemsHetHan.isEmpty
                                  ? backGroundColor
                                  : mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // giá trị này xác định bán kính bo tròn
                          ),
                        ),
                        onPressed: selectedItemsHetHan.isEmpty
                            ? null
                            : () {
                                NetWork.checkConnection().then((value) {
                                  if (value == "Not Connected") {
                                    MyDialog.showAlertDialogOneBtn(
                                        context,
                                        "Không có Internet",
                                        "Vui lòng kết nối internet và thử lại sau");
                                  } else {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: XuatKhoHetHanScreen(
                                                selectedItemsHetHan:
                                                    selectedItemsHetHan)));
                                  }
                                });
                              },
                        child: Text(
                          'Xuất kho',
                          style: TextStyle(fontSize: Font.sizes(context)[2]),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox());
  }
}
