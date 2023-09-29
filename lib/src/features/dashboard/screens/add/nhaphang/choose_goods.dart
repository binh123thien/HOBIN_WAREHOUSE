import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../utils/utils.dart';
import '../../../controllers/add/chonhanghoa_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import 'widget/location_widget.dart';

class ChooseGoodsScreen extends StatefulWidget {
  const ChooseGoodsScreen({super.key});

  @override
  State<ChooseGoodsScreen> createState() => _ChooseGoodsScreenState();
}

class _ChooseGoodsScreenState extends State<ChooseGoodsScreen> {
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final controllerLocation = Get.put(GoodRepository());
  String searchHangHoa = "";
  List<dynamic> allHangHoa = [];
  List<dynamic> filteredItems = [];

  bool isSelected =
      false; // Biến để theo dõi trạng thái Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  List<bool> itemExpandedList = List.generate(200, (index) => false);

  @override
  void initState() {
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    filteredItems = allHangHoa;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Chọn hàng hóa", style: TextStyle(fontSize: 18)),
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
                            searchHangHoa = value;
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final doc = filteredItems[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: doc["photoGood"].isEmpty
                                    ? const Image(
                                        image: AssetImage(hanghoaIcon),
                                        height: 30,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          height: 30,
                                          width: 30,
                                          imageUrl: doc["photoGood"].toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc["tensanpham"]),
                                    Text(
                                      "Kho: ${doc["tonkho"]} ${doc["donvi"]} - ${formatCurrency(doc["gianhap"])}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w100),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      itemExpandedList[index] =
                                          !itemExpandedList[index];
                                    });
                                  },
                                  child: const Icon(
                                    Icons.expand_circle_down,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              itemExpandedList[index] == true
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 7),
                                        DotLineWidget.dotLine(context),
                                        const SizedBox(height: 7),
                                        LocationWidget(hanghoa: doc)
                                      ],
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
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
        ));
  }
}
