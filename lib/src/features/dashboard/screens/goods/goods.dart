import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/search_widget.dart';

import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/card_hanghoa_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import '../../controllers/add/chonhanghoa_controller.dart';
import 'chitiethanghoa.dart';
import 'widget/sorbyhanghoa/danhsach_sortby.dart';
import 'widget/them_hang_hoa.dart';

class Goods extends StatefulWidget {
  const Goods({super.key});

  @override
  State<Goods> createState() => _GoodsState();
}

class _GoodsState extends State<Goods> with TickerProviderStateMixin {
  String searchHangHoa = "";
  //=======================show option sortby===============================
  final controllersortby = Get.put(ThemHangHoaController());

  Future<void> _showSortbyHangHoa() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return DanhSachSortByHangHoa(
          sortbyhanghoaController: controllersortby.sortbyhanghoaController,
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllersortby.sortbyhanghoaController.text = selectedValue;
      });
    }
  }

  // Khởi tạo biến cho trang Sỉ và Lẻ
  bool _lePageVisible = true;
  bool _siPageVisible = false;
  final controllerRepo = Get.put(GoodRepository());
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  //tạo list hangHoaLe
  late List<dynamic> allHangHoa = [];

  @override
  void initState() {
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Xác định hàng hóa bán lẻ
    List<dynamic> allHangHoaLe = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán lẻ'))
        .toList();

    // Xác định hàng hóa bán sỉ
    List<dynamic> allHangHoaSi = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán sỉ'))
        .toList();

    // Sắp xếp danh sách theo thứ tự tăng dần của "tonkho"
    controllerRepo.sortby(
        allHangHoa, controllersortby.sortbyhanghoaController.text);

    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong lẻ
    List<dynamic> filteredItemsLe = allHangHoaLe
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();

    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong sỉ
    List<dynamic> filteredItemsSi = allHangHoaSi
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: SearchWidget(
            onChanged: (value) {
              setState(() {
                searchHangHoa = value;
              });
            },
            width: 270,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: SizedBox(
              width: 300,
              height: 50,
              child: CupertinoSlidingSegmentedControl(
                children: const {
                  0: Text("        Lẻ        ", style: TextStyle(fontSize: 17)),
                  1: Text("        Sỉ        ", style: TextStyle(fontSize: 17)),
                },
                padding: const EdgeInsets.all(6),
                backgroundColor: pink200Color,
                groupValue: _lePageVisible ? 0 : 1,
                onValueChanged: (int? newValue) {
                  setState(() {
                    _lePageVisible = newValue == 0;
                    _siPageVisible = newValue == 1;
                  });
                },
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage(tBackGround1), // where is this variable defined?
                fit: BoxFit.cover,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _showSortbyHangHoa();
                },
                icon: const Image(
                  image: AssetImage(sortyWhiteIcon),
                  height: 25,
                ))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_lePageVisible)
              SizedBox(
                width: size.width,
                height: size.height - 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: filteredItemsLe.length,
                    itemBuilder: (context, index) {
                      var hanghoa = filteredItemsLe[index];
                      return CardHangHoa(
                        hangHoaChoosed: hanghoa,
                        phanBietSiLe: false,
                        hinhanh: hanghoa['photoGood'],
                        donvi: hanghoa["donvi"],
                        tensanpham: hanghoa["tensanpham"].toString(),
                        tonkho: hanghoa["tonkho"].toString(),
                        giaban: hanghoa["giaban"],
                        daban: hanghoa["daban"].toString(),
                        onTapChiTietHangHoa: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChiTietHangHoaScreen(hanghoa: hanghoa)),
                          ).then((_) {
                            setState(() {
                              allHangHoa =
                                  controllerAllHangHoa.allHangHoaFireBase;
                            });
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            if (_siPageVisible)
              SizedBox(
                width: size.width,
                height: size.height - 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: filteredItemsSi.length,
                    itemBuilder: (context, index) {
                      var hanghoa = filteredItemsSi[index];
                      return CardHangHoa(
                        hangHoaChoosed: hanghoa,
                        phanBietSiLe: true,
                        hinhanh: hanghoa['photoGood'],
                        donvi: hanghoa["donvi"],
                        tensanpham: hanghoa["tensanpham"],
                        tonkho: hanghoa["tonkho"].toString(),
                        giaban: hanghoa["giaban"],
                        daban: hanghoa["daban"].toString(),
                        onTapChiTietHangHoa: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChiTietHangHoaScreen(hanghoa: hanghoa)),
                          ).then((_) {
                            setState(() {
                              allHangHoa =
                                  controllerAllHangHoa.allHangHoaFireBase;
                            });
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemGoodsScreen()),
          ).then((_) {
            setState(() {
              allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
            });
          });
        },
        backgroundColor: mainColor,
        icon: const Icon(Icons.add),
        label: const Text("Thêm"),
      ),
    );
  }
}
