import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../utils/validate/validate.dart';
import '../../../../../controllers/home/hethan_controller.dart';

class XuatKhoHetHanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItemsHetHan;
  const XuatKhoHetHanScreen({super.key, required this.selectedItemsHetHan});

  @override
  State<XuatKhoHetHanScreen> createState() => _XuatKhoHetHanScreenState();
}

class _XuatKhoHetHanScreenState extends State<XuatKhoHetHanScreen> {
  final controller = Get.put(HetHanController());
  @override
  Widget build(BuildContext context) {
    final _formKey1 = GlobalKey<FormState>();
    int totalPrice = widget.selectedItemsHetHan
        .map<int>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    int totalQuantity = widget.selectedItemsHetHan
        .map<int>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text("Xuất kho hết hạn",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
          backgroundColor: mainColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: backGround600Color)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Ước tính doanh thu",
                              style: TextStyle(fontSize: 17)),
                          const SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tổng tiền:",
                                  style: TextStyle(fontSize: 17)),
                              Text(formatCurrency(totalPrice),
                                  style: const TextStyle(fontSize: 17)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tổng số lượng:",
                                  style: TextStyle(fontSize: 17)),
                              Text(totalQuantity.toString(),
                                  style: const TextStyle(fontSize: 17)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng tiền xuất thực tế:",
                          style: TextStyle(fontSize: 17)),
                      TextFormField(
                        validator: (value) {
                          return oneCharacter(value!);
                        },
                        controller: controller.giaHetHanController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        onChanged: (value) {
                          final newValue = formatNumber(value);
                          if (newValue != value) {
                            controller.giaHetHanController.value =
                                TextEditingValue(
                              text: newValue,
                              selection: TextSelection.fromPosition(
                                  TextPosition(offset: newValue.length)),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 15),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainColor, width: 2)),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Nhập số tiền'),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.selectedItemsHetHan.length,
                  itemBuilder: (context, index) {
                    final docdata = widget.selectedItemsHetHan[index];
                    return Column(
                      children: [
                        ListTile(
                            leading: CircleAvatar(
                              backgroundColor: backGroundColor,
                              foregroundColor: mainColor,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                            title: Text(
                              "${docdata['tensanpham']} - ${docdata['gia']}",
                            ),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${docdata["exp"]} - SL: ${docdata["soluong"]}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${docdata["location"]}",
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ])
                            // Các thuộc tính khác của CheckboxListTile
                            // ...
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
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      side: const BorderSide(color: mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: () {
                      if (_formKey1.currentState!.validate()) {
                        print(controller.giaHetHanController.value.text);
                      }
                    },
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
