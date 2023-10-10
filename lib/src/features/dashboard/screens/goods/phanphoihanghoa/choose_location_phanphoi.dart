import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/add/nhaphang_controller.dart';
import '../../Widget/appbar/search_widget.dart';

class ChooseLocationPhanPhoiScreen extends StatefulWidget {
  final dynamic hangHoaLe;
  final List<Map<String, dynamic>> locationUsed;
  const ChooseLocationPhanPhoiScreen(
      {super.key, required this.locationUsed, this.hangHoaLe});

  @override
  State<ChooseLocationPhanPhoiScreen> createState() =>
      _ChooseLocationPhanPhoiScreenState();
}

class _ChooseLocationPhanPhoiScreenState
    extends State<ChooseLocationPhanPhoiScreen> with InputValidationMixin {
  String searchLocation = "";
  final controllerLocation = Get.put(NhapHangController());
  List<dynamic> allLocationName = [];
  //list chưa sử dụng
  List<dynamic> unusedLocations = [];
  List<dynamic> unusedLocationsSearch = [];

  List<dynamic> usedLocations = [];

  bool isSelected =
      false; // Biến để theo dõi trạng thái Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  @override
  void initState() {
    super.initState();
    //list unusedLocationsSearch tạm để search
    unusedLocationsSearch = unusedLocations;
    //load all location
    controllerLocation.loadAllLocationsName();
    usedLocations = widget.locationUsed;
    allLocationName = controllerLocation.allLocationNameFirebase;
    for (var location in allLocationName) {
      bool isUsed = widget.locationUsed
          .any((usedLocation) => usedLocation['location'] == location['id']);
      if (!isUsed) {
        unusedLocations.add(location);
      }
    }
  }

  void runFilter(String enterKeyboard) {
    List<dynamic> resultUnUsedLocations = [];
    List<dynamic> resultUsedLocations = [];

    if (enterKeyboard.isEmpty) {
      // Nếu chuỗi tìm kiếm trống, hiển thị tất cả các vị trí chưa sử dụng và đang sử dụng
      resultUnUsedLocations = (unusedLocationsSearch);
      resultUsedLocations = (widget.locationUsed);
    } else {
      // Nếu có chuỗi tìm kiếm, lặp qua cả hai danh sách và thêm các phần tử thỏa mãn vào danh sách kết quả
      for (var location in unusedLocations) {
        if (location['id']
            .toString()
            .toLowerCase()
            .contains(enterKeyboard.toLowerCase())) {
          resultUnUsedLocations.add(location);
        }
      }

      for (var location in usedLocations) {
        if (location['location']
            .toString()
            .toLowerCase()
            .contains(enterKeyboard.toLowerCase())) {
          resultUsedLocations.add(location);
        }
      }
    }

    setState(() {
      unusedLocations = resultUnUsedLocations;
      usedLocations = resultUsedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("Chọn vị trí", style: TextStyle(fontSize: 18)),
        backgroundColor: blueColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: whiteColor,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SearchWidget(
                      onChanged: (value) {
                        setState(() {
                          runFilter(value);
                        });
                      },
                      width: 320,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Text('Vị trí ${widget.hangHoaLe['tensanpham']} đang sử dụng'),
          usedLocations.isNotEmpty
              ? ListView.builder(
                  physics: const PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: usedLocations.length,
                  itemBuilder: (context, index) {
                    final doc = widget.locationUsed[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                            selectedDoc = doc;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: isSelected && selectedDoc == doc ? 2 : 1,
                              color: isSelected && selectedDoc == doc
                                  ? Colors
                                      .blue // Màu border khi Container được chọn
                                  : Colors
                                      .black26, // Màu border khi Container không được chọn
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(doc["location"]),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          PhanCachWidget.dotLine(context),
          const SizedBox(height: 5),
          const Text('Vị trí chưa sử dụng'),
          unusedLocations.isNotEmpty
              ? ListView.builder(
                  physics: const PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: unusedLocations.length,
                  itemBuilder: (context, index) {
                    final doc = unusedLocations[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                            selectedDoc = doc;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: isSelected && selectedDoc == doc ? 2 : 1,
                              color: isSelected && selectedDoc == doc
                                  ? Colors
                                      .blue // Màu border khi Container được chọn
                                  : Colors
                                      .black26, // Màu border khi Container không được chọn
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(doc["id"]),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ],
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
                    backgroundColor: blueColor,
                    side: const BorderSide(color: blueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: selectedDoc != null
                      ? () {
                          Navigator.of(context).pop(selectedDoc);
                        }
                      : null,
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
