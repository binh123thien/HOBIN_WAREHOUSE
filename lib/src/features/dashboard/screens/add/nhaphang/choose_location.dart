import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/add/nhaphang_controller.dart';
import '../../Widget/appbar/search_widget.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  String searchLocation = "";
  final controllerLocation = Get.put(NhapHangController());
  List<dynamic> allLocationName = [];

  bool isSelected =
      false; // Biến để theo dõi trạng thái Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  @override
  void initState() {
    super.initState();
    controllerLocation.loadAllLocationsName();
    allLocationName = controllerLocation.allLocationNameFirebase;
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
                          searchLocation = value;
                        });
                      },
                      width: 320,
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     _showSortbyHangHoaTaoDon();
                    //   },
                    //   icon: const Image(
                    //     image: AssetImage(sortbyIcon),
                    //     height: 28,
                    //   ),
                    // ),
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
          ListView.builder(
            physics: const PageScrollPhysics(),
            shrinkWrap: true,
            itemCount: allLocationName.length,
            itemBuilder: (context, index) {
              final doc = allLocationName[index];
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
                            ? Colors.blue // Màu border khi Container được chọn
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
                          10), // giá trị này xác định bán kính bo tròn
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
