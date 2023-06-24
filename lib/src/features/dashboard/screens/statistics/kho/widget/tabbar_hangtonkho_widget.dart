import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

import '../../../../../../repository/goods_repository/good_repository.dart';
import '../../../../controllers/add/chonhanghoa_controller.dart';
import '../../../../controllers/goods/sortby_controller.dart';
import '../../../Widget/appbar/search_widget.dart';
import '../../../Widget/card_danhsach_3cot_widget.dart';
import 'phanloaihang_widget.dart';
import 'sortby_hanghoa_kho.dart';

class TabbarHangTonKhoWidget extends StatefulWidget {
  const TabbarHangTonKhoWidget({super.key});

  @override
  State<TabbarHangTonKhoWidget> createState() => _TabbarHangTonKhoWidgetState();
}

class _TabbarHangTonKhoWidgetState extends State<TabbarHangTonKhoWidget>
    with TickerProviderStateMixin {
  final controller = Get.put(GoodRepository());
  final controllerSortby = Get.put(SortbyHangHoaController());
  final controllerHangHoa = Get.put(ChonHangHoaController());
  @override
  void initState() {
    super.initState();
    controllerHangHoa.loadAllHangHoa();
  }

  String searchKhachHang = "";
  Future<void> _showSortbyKhachHang() async {
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
        return DanhSachSortByHangHoaKho(
            sortbyHangHoaKhoController: controllerSortby
                .sortbyHangHoaKhoController); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllerSortby.sortbyHangHoaKhoController.text = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.sortby(controllerHangHoa.allHangHoaFireBase,
        controllerSortby.sortbyHangHoaKhoController.text);
    List<dynamic> filteredItems = controllerHangHoa.allHangHoaFireBase
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchKhachHang.toLowerCase()))
        .toList();
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: backGroundColor,
            title: const TabBar(
              tabs: [
                Tab(
                  text: "Hàng tồn kho",
                ),
                Tab(
                  text: "Phân loại",
                ),
              ],
              indicatorColor: mainColor,
              labelColor: darkColor,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 145,
            child: TabBarView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SearchWidget(
                            onChanged: (value) {
                              setState(() {
                                searchKhachHang = value;
                              });
                            },
                            width: 320,
                          ),
                          IconButton(
                              onPressed: () {
                                _showSortbyKhachHang();
                              },
                              icon: const Image(
                                image: AssetImage(sortbyIcon),
                                height: 30,
                              ))
                        ],
                      ),
                    ),
                    CardDanhSach3cotWidget(
                      hangTonKho: filteredItems,
                      title1: 'Tên hàng hóa',
                      title2: 'Tồn kho',
                      title3: 'Đã bán',
                      nameArrTitle1: 'tensanpham',
                      nameArrTitle2: 'tonkho',
                      nameArrTitle3: 'daban',
                    ),
                  ],
                ),
                const PhanLoaiKhoWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
