import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/card_donhang_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/search_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';

import '../../controllers/add/chonhanghoa_controller.dart';
import '../goods/widget/them_hang_hoa.dart';
import 'nhaphang.dart';
import 'them_donhang.dart';
import 'widget/themdonhang/danhsachsortby_hanghoa_taodon.dart';

// ignore: must_be_immutable
class ChooseGoodsScreen extends StatefulWidget {
  final int phanbietNhapXuat;
  List<TextEditingController> controllers;
  ChooseGoodsScreen(
      {super.key, required this.controllers, required this.phanbietNhapXuat});

  @override
  State<ChooseGoodsScreen> createState() => _ChooseGoodsScreenState();
}

class _ChooseGoodsScreenState extends State<ChooseGoodsScreen> {
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final ChonHangHoaController chonHangHoaController = Get.find();
  final controllersortby = Get.put(ThemHangHoaController());
  final controllerGoodRepo = Get.put(GoodRepository());

  String searchHangHoa = "";
  late List<dynamic> allHangHoa;
  List<dynamic> filteredItems = [];
  Map<dynamic, TextEditingController> controllerMap = {};
  @override
  void initState() {
    super.initState();
    allHangHoa = chonHangHoaController.allHangHoaFireBase;
    filteredItems = allHangHoa;
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
        widget.controllers =
            List.generate(filteredItems.length, (_) => TextEditingController());
        for (int i = 0; i < filteredItems.length; i++) {
          widget.controllers[i].text = filteredItems[i]["soluong"].toString();
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
        child: CardItemBanHang(
          phanbietNhapXuat: widget.phanbietNhapXuat,
          allHangHoa: filteredItems,
          controllerSoluong: widget.controllers,
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
              height: 55,
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
                              builder: (context) => const ThemDonHangScreen()),
                        );
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NhapHangScreen()),
                        );
                      },
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 22),
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
              .contains(searchHangHoa))
          .toList();
      controllerGoodRepo.sortby(
          filteredItems, controllersortby.sortbyhanghoaTaoDonController.text);
      widget.controllers =
          List.generate(filteredItems.length, (_) => TextEditingController());
      for (int i = 0; i < filteredItems.length; i++) {
        var itemId = filteredItems[i]["tensanpham"];
        if (controllerMap.containsKey(itemId)) {
          widget.controllers[i] = controllerMap[itemId]!;
        } else {
          controllerMap[itemId] = TextEditingController();
          widget.controllers[i] = controllerMap[itemId]!;
        }
        widget.controllers[i].text = filteredItems[i]["soluong"].toString();
      }
    });
  }
}
