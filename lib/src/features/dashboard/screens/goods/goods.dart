import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
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
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return DanhSachSortByHangHoa(
          sortbyhanghoaController: controllersortby.sortbyhanghoaController,
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    ).then((value) {
      setState(() {
        controllersortby.sortbyhanghoaController.text = value!;
      });
    });
  }

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: const Text("Hàng Hóa",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: whiteColor)),
          backgroundColor: mainColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(95),
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
                            _showSortbyHangHoa();
                          },
                          icon: const Image(
                            image: AssetImage(sortbyIcon),
                            height: 28,
                          )),
                    ],
                  ),
                  const TabBar(
                    tabs: [
                      Tab(
                        text: "Lẻ",
                      ),
                      Tab(
                        text: "Sỉ",
                      ),
                    ],
                    indicatorColor: Colors.pink,
                    labelColor: darkColor,
                    isScrollable: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
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
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
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
          ],
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
      ),
    );
  }
}
