import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/add/nhaphang_controller.dart';
import '../../Widget/appbar/search_widget.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen>
    with InputValidationMixin {
  String searchLocation = "";
  final controllerLocation = Get.put(NhapHangController());
  List<dynamic> allLocationName = [];

  final TextEditingController _controllerLocation = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isSelected =
      false; // Biến để theo dõi trạng thái Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  @override
  void initState() {
    super.initState();
    controllerLocation.loadAllLocationsName();
    allLocationName = controllerLocation.allLocationNameFirebase;
  }

  void runFilter(String enterKeyboard) {
    final allLocation = controllerLocation.allLocationNameFirebase;
    List<dynamic> result = [];
    if (enterKeyboard.isEmpty) {
      result = allLocation;
    } else {
      result = allLocation
          .where((locationName) => locationName['id']
              .toString()
              .toLowerCase()
              .contains(enterKeyboard.toLowerCase()))
          .toList();
    }
    setState(() {
      allLocationName = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.27,
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Text("Nhập vị trí"),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    return locationNameCheckForm(
                                        value!, allLocationName);
                                  },
                                  controller: _controllerLocation,
                                  maxLength: 10,
                                  decoration: const InputDecoration(
                                      errorStyle: TextStyle(fontSize: 15),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: blueColor, width: 2)),
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'Nhập vị trí'),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controllerLocation.createLocationName(
                                            _controllerLocation.text);
                                        //thêm vào list local
                                        allLocationName.add(
                                            {'id': _controllerLocation.text});
                                        setState(() {});
                                        Navigator.of(context)
                                            .pop(_controllerLocation.text);
                                      }
                                    },
                                    child: const Text(
                                      'Xác nhận',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add))
        ],
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
