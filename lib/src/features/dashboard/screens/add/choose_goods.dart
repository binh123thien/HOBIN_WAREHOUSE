import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/card_donhang_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/search_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';

import '../../controllers/add/chonhanghoa_controller.dart';
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            leading: IconButton(
                icon: const Image(
                  image: AssetImage(backIcon),
                  height: 20,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.pop(context, widget.controllers);
                }),
            title: const Text("Hàng Hóa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SearchWidget(
                  onChanged: (value) {
                    onSearchTextChanged(value);
                  },
                  width: 330,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      tBackGround1), // where is this variable defined?
                  fit: BoxFit.cover,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    _showSortbyHangHoaTaoDon();
                  },
                  icon: const Image(
                    image: AssetImage(sortyWhiteIcon),
                    height: 25,
                  ))
            ],
          ),
        ),
        body: CardItemBanHang(
          phanbietNhapXuat: widget.phanbietNhapXuat,
          allHangHoa: filteredItems,
          controllerSoluong: widget.controllers,
        ));
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
