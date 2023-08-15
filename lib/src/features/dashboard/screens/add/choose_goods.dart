import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/search_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';

import '../../controllers/add/chonhanghoa_controller.dart';
import '../goods/widget/them_hang_hoa.dart';
import 'nhaphang.dart';
import 'nhaphang/cardnhaphangshowmore.dart';
import 'them_donhang.dart';
import 'widget/themdonhang/danhsachsortby_hanghoa_taodon.dart';

// ignore: must_be_immutable
class ChooseGoodsScreen extends StatefulWidget {
  final int phanbietNhapXuat;
  const ChooseGoodsScreen({super.key, required this.phanbietNhapXuat});

  @override
  State<ChooseGoodsScreen> createState() => _ChooseGoodsScreenState();
}

class _ChooseGoodsScreenState extends State<ChooseGoodsScreen> {
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final controllersortby = Get.put(ThemHangHoaController());
  final controllerGoodRepo = Get.put(GoodRepository());
  List<TextEditingController> controllersl = [];

  String searchHangHoa = "";
  List<dynamic> allHangHoa = [];
  List<dynamic> filteredItems = [];
  Map<dynamic, TextEditingController> controllerMap = {};
  @override
  void initState() {
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    filteredItems = allHangHoa;
    super.initState();
  }

  Future<void> _showSortbyHangHoaTaoDon() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return DanhSachSortByHangHoaTaoDon(
          sortbyhanghoaTaoDonController:
              controllersortby.sortbyhanghoaTaoDonController,
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllersortby.sortbyhanghoaTaoDonController.text = selectedValue;
        locdulieu();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    locdulieu();
    for (var item in filteredItems) {
      controllerMap[item['tensanpham']] = TextEditingController();
    }
    void onSearchTextChanged(String value) {
      setState(() {
        searchHangHoa = value.toLowerCase();
        filteredItems = allHangHoa
            .where((item) => item["tensanpham"]
                .toString()
                .toLowerCase()
                .contains(searchHangHoa))
            .toList();
        controllersl =
            List.generate(filteredItems.length, (_) => TextEditingController());
        for (int i = 0; i < filteredItems.length; i++) {
          controllersl[i].text = filteredItems[i]["soluong"].toString();
        }
      });
      locdulieu();
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.phanbietNhapXuat == 0
            ? const Text(
                "Thêm đơn hàng",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: whiteColor),
              )
            : const Text(
                "Nhập hàng",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: whiteColor),
              ),
        backgroundColor: widget.phanbietNhapXuat == 0 ? mainColor : blueColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline_outlined,
                size: 30,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThemGoodsScreen()),
                ).then((_) {
                  setState(() {
                    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
                  });
                });
              },
            ),
          ),
        ],
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
                    IconButton(
                      onPressed: () {
                        _showSortbyHangHoaTaoDon();
                      },
                      icon: const Image(
                        image: AssetImage(sortbyIcon),
                        height: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: filteredItems.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height - 230,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          var hanghoa = filteredItems[index];
                          return CardNhapHangShowMore(
                            hanghoa: hanghoa,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : allHangHoa.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Center(
                      child: Text(
                        "Chưa có hàng hóa...",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Center(
                      child: Text(
                        "Không tìm thấy hàng hóa!",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.phanbietNhapXuat == 0 ? mainColor : blueColor,
                  side: BorderSide(
                      color:
                          widget.phanbietNhapXuat == 0 ? mainColor : blueColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // giá trị này xác định bán kính bo tròn
                  ),
                ),
                onPressed: widget.phanbietNhapXuat == 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThemDonHangScreen(
                              dulieuPicked: filteredItems,
                              slpick: controllersl,
                            ),
                          ),
                        );
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NhapHangScreen(
                              dulieuPicked: filteredItems,
                              slpick: controllersl,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void locdulieu() {
    setState(() {
      filteredItems = allHangHoa
          .where((item) => item["tensanpham"]
              .toString()
              .toLowerCase()
              .contains(searchHangHoa.toLowerCase()))
          .toList();
      controllerGoodRepo.sortby(
          filteredItems, controllersortby.sortbyhanghoaTaoDonController.text);
      controllersl =
          List.generate(filteredItems.length, (_) => TextEditingController());
      for (int i = 0; i < filteredItems.length; i++) {
        var itemId = filteredItems[i]["tensanpham"];
        if (controllerMap.containsKey(itemId)) {
          controllersl[i] = controllerMap[itemId]!;
        } else {
          controllerMap[itemId] = TextEditingController();
          controllersl[i] = controllerMap[itemId]!;
        }
        controllersl[i].text = filteredItems[i]["soluong"].toString();
      }
    });
  }
}
