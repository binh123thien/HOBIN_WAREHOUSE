import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../repository/goods_repository/good_repository.dart';
import '../../../../controllers/goods/chondonvi_controller.dart';
import '../../../../controllers/goods/them_hanghoa_controller.dart';

class DanhSachDonVi extends StatefulWidget {
  const DanhSachDonVi({super.key});

  @override
  State<DanhSachDonVi> createState() => _DanhSachDonViState();
}

class _DanhSachDonViState extends State<DanhSachDonVi> {
  final ChonDonViController chonDonViController = Get.find();

  final controller = Get.put(ThemHangHoaController());
  final controllerGoodRepo = Get.put(GoodRepository());
  //để lắng nghe dữ liệu thay đổi
  late List<dynamic> foundDonVi;
  @override
  void initState() {
    super.initState();
    foundDonVi = chonDonViController.allDonViFirebase;
    //gán gtri ban dau: controller của thanh search = rỗng
    controller.searchController.text = '';
    // Gán gtri bd foundDonVi để lắng nghe sự thay đổi (của List tĩnh)
  }

  void runFilter(String enterKeyboard) {
    final allDonVi = chonDonViController.allDonViFirebase;
    List<dynamic> result = [];
    if (enterKeyboard.isEmpty) {
      result = allDonVi;
    } else {
      result = allDonVi
          .where((user) =>
              user.toLowerCase().contains(enterKeyboard.toLowerCase()))
          .toList();
    }
    setState(() {
      // cập nhật giá trị mới cho foundDonVi (foundDonVi.add = result;)
      foundDonVi = result;
    });
    // print(foundDonVi); // in ra kết quả mới của foundDonVi
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    'Danh sách đơn vị',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -10,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_rounded)),
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
                        onPressed: () async {
                          // kiểm tra giá trị nhập vào thành tìm kiếm
                          var searchText = controller.searchController.text;
                          if (searchText.isEmpty) {
                            searchText = 'bạn chưa nhập đơn vị';
                          }

                          void addDonVi() {
                            if (controller.searchController.text == '') {
                              Get.snackbar(
                                  "Có lỗi xảy ra", "Bạn chưa nhập đơn vị mới",
                                  colorText: Colors.red);
                              return;
                            }
                            //nếu tìm kiếm list DS rỗng
                            if (foundDonVi.isEmpty) {
                              chonDonViController.createDonViMoi(
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
                              for (int i = 0; i < foundDonVi.length; i++) {
                                if (controller.searchController.text ==
                                    foundDonVi[i]) {
                                  isFound = true;
                                  break; // Thoát khỏi vòng lặp khi tìm thấy phần tử trùng
                                }
                              }
                              if (isFound) {
                                Get.snackbar("Có lỗi xảy ra",
                                    "Đơn vị đã có trong danh sách",
                                    colorText: Colors.red);
                              }
                              //không trùng
                              else {
                                chonDonViController.createDonViMoi(
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
                              'Bạn muốn thêm đơn vị ?',
                              'Đơn vị mới sẽ là: ${searchText}',
                              () => addDonVi());
                        }))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: foundDonVi.length,
                itemBuilder: (context, index) {
                  final donvi = foundDonVi[index];
                  return Dismissible(
                    key: Key(donvi),
                    // direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      print('không cho auto xóa');
                    },
                    confirmDismiss: (direction) async {
                      MyDialog.showAlertDialog(
                          context, 'Xác nhận', "Bạn có muốn xóa ?", () {
                        chonDonViController.deleteDonviByTen(donvi);
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
                        child: GestureDetector(
                          onTap: () {
                            // Xử lý khi người dùng nhấn vào
                            Navigator.of(context).pop(donvi);
                          },
                          child: Center(
                            child: Text(
                              donvi,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
