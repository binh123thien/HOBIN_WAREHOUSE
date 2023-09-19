import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/chondanhmuc_controller.dart';

import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../controllers/goods/them_hanghoa_controller.dart';

class DanhSachDanhMuc extends StatefulWidget {
  final List<String> selectedUnits;
  const DanhSachDanhMuc({super.key, required this.selectedUnits});

  @override
  State<DanhSachDanhMuc> createState() => _DanhSachDanhMucState(selectedUnits);
}

class _DanhSachDanhMucState extends State<DanhSachDanhMuc> {
  final ChonDanhMucController chonDanhMucController = Get.find();
  final controller = Get.put(ThemHangHoaController());

  // ===========================Search===========================//
  //để lắng nghe dữ liệu thay đổi
  late List<dynamic> foundDanhMuc;

  Set<String> selectedDanhMuc = <String>{};

  _DanhSachDanhMucState(List<String> selectedUnits) {
    final allDanhMuc = chonDanhMucController.allDanhMucFirebase;
    // add selected units to selectedDonvi set
    selectedDanhMuc.addAll(selectedUnits);
    foundDanhMuc = allDanhMuc;
  }
  @override
  void initState() {
    super.initState();
    foundDanhMuc = chonDanhMucController.allDanhMucFirebase;
    //gán gtri ban dau: controller của thanh search = rỗng

    controller.searchController.text = '';
    // Gán gtri bd foundDonVi để lắng nghe sự thay đổi (của List tĩnh)
  }

  void runFilter(String enterKeyboard) {
    final allDanhMuc = chonDanhMucController.allDanhMucFirebase;
    List<dynamic> result = [];
    if (enterKeyboard.isEmpty) {
      result = allDanhMuc;
    } else {
      result = allDanhMuc
          .where((user) =>
              user.toLowerCase().contains(enterKeyboard.toLowerCase()))
          .toList();
    }
    setState(() {
      // cập nhật giá trị mới cho foundDanhMuc(foundDanhMuc.add = result;)
      foundDanhMuc = result;
    });
  }

// ===========================End Search===========================//
// ===========================Delete don vi===========================//
// ===========================End Delete don vi===========================//

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //padding đẩy danh mục
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: size.height * 0.6,
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
        child: Column(
          children: [
            const Divider(
              // thêm Divider
              height: 1,
              thickness: 5,
              color: backGroundColor,
              indent: 120,
              endIndent: 120,
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Danh sách danh mục',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -10,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () {
                        List<String> selected = selectedDanhMuc.toList();
                        Navigator.pop(context, selected);
                      },
                      icon: const Icon(Icons.done)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: (value) => runFilter(value),
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: whiteColor, // where is this color defined?
                        contentPadding: EdgeInsets.zero,
                        prefixIconColor: darkColor,
                        floatingLabelStyle: const TextStyle(color: darkColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              const BorderSide(width: 2, color: pink600Color),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Tìm Kiếm",
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                      child: const Text("Thêm",
                          style: TextStyle(fontSize: 17, color: mainColor)),
                      onPressed: () {
                        // kiểm tra giá trị nhập vào thành tìm kiếm
                        var searchText = controller.searchController.text;
                        print('bấm thêm nè');
                        print(searchText);
                        if (searchText.isEmpty) {
                          searchText = 'bạn chưa nhập đơn vị';
                        }
                        void addDanhMuc() {
                          if (controller.searchController.text == '') {
                            Get.snackbar(
                                "Có lỗi xảy ra", "Bạn chưa nhập danh mục mới",
                                colorText: Colors.red);
                            return;
                          }
                          //nếu tìm kiếm list DS rỗng
                          if (foundDanhMuc.isEmpty) {
                            chonDanhMucController.createDanhMucMoi(
                                controller.searchController.text);
                            Navigator.of(context).pop(
                                false); // Đóng dialog và trả về giá trị false
                            //Đóng bottomsheet
                            Navigator.of(context).pop();
                          }
                          //kiểm tra TH có dữ liệu trong DS
                          else {
                            bool isFound = false;
                            //kiếm tra dữ liệu nhập vào tìm kiếm và list có trùng không
                            for (int i = 0; i < foundDanhMuc.length; i++) {
                              if (controller.searchController.text ==
                                  foundDanhMuc[i]) {
                                isFound = true;
                                break; // Thoát khỏi vòng lặp khi tìm thấy phần tử trùng
                              }
                            }
                            if (isFound) {
                              Get.snackbar("Có lỗi xảy ra",
                                  "Danh mục đã có trong danh sách",
                                  colorText: Colors.red);
                            }
                            //không trùng
                            else {
                              chonDanhMucController.createDanhMucMoi(
                                  controller.searchController.text);
                              print(
                                  "add thanh cong TH list không có giá trị trùng");
                              Navigator.of(context).pop(
                                  false); // Đóng dialog và trả về giá trị false
                              //Đóng bottomsheet
                              Navigator.of(context).pop();
                            }
                          }
                        }

                        MyDialog.showAlertDialog(
                            context,
                            'Bạn muốn thêm danh mục ?',
                            'Danh mục mới sẽ là: $searchText',
                            0,
                            () => addDanhMuc());
                      },
                    ))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: foundDanhMuc.length,
                itemBuilder: ((context, index) {
                  final danhmuc = foundDanhMuc[index];
                  return Dismissible(
                    key: Key(danhmuc),
                    // direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      print('không cho auto xóa');
                    },
                    confirmDismiss: (direction) async {
                      MyDialog.showAlertDialog(
                          context, 'Xác nhận', "Bạn có muốn xóa ?", 0, () {
                        chonDanhMucController.deleteDanhMucByTen(danhmuc);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                      return null;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: Card(
                        color: whiteColor,
                        elevation: 1,
                        child: CheckboxListTile(
                          checkboxShape: const CircleBorder(),
                          activeColor: mainColor,
                          checkColor: mainColor,
                          value: selectedDanhMuc.contains(danhmuc),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                selectedDanhMuc.add(danhmuc);
                              } else {
                                selectedDanhMuc.remove(danhmuc);
                              }
                            });
                          },
                          title: Text(
                            foundDanhMuc[index],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
