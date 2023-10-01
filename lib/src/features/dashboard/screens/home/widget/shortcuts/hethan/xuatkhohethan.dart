import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
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
    num totalPrice = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    num totalQuantity = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'])
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26)),
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
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: Image(
                                        image: AssetImage(tongtienxuatkhoIcon)),
                                  ),
                                  SizedBox(width: 5),
                                  Text("Tổng tiền:",
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                              Text(formatCurrency(totalPrice),
                                  style: const TextStyle(fontSize: 17)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: Image(
                                        image:
                                            AssetImage(tongsoluongxuatkhoIcon)),
                                  ),
                                  SizedBox(width: 5),
                                  Text("Tổng số lượng:",
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                              Text(totalQuantity.toString(),
                                  style: const TextStyle(fontSize: 17)),
                            ],
                          ),
                          const SizedBox(height: 7),
                          PhanCachWidget.dotLine(context),
                          Padding(
                            padding: const EdgeInsets.only(top: 13, bottom: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    return oneCharacter(value!);
                                  },
                                  controller: controller.giaHetHanController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  onChanged: (value) {
                                    final newValue = formatNumber(value);
                                    if (newValue != value) {
                                      controller.giaHetHanController.value =
                                          TextEditingValue(
                                        text: newValue,
                                        selection: TextSelection.fromPosition(
                                            TextPosition(
                                                offset: newValue.length)),
                                      );
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Tiền thực tế",
                                      errorStyle: TextStyle(fontSize: 15),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: mainColor, width: 1)),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      hintText: 'Nhập số tiền'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Danh sách đã chọn",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26)),
                    child: ListView.builder(
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
                            index != widget.selectedItemsHetHan.length - 1
                                ? PhanCachWidget.dotLine(context)
                                : const SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
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
