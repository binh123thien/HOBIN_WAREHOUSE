import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/widget/sorbyhanghoa/danhsach_sortby.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../utils/utils.dart';
import '../../../controllers/add/chonhanghoa_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import 'widget/location_widget.dart';

class ChooseGoodsScreen extends StatefulWidget {
  final int phanBietNhapXuat;
  const ChooseGoodsScreen({super.key, required this.phanBietNhapXuat});
  @override
  State<ChooseGoodsScreen> createState() => _ChooseGoodsScreenState();
}

class _ChooseGoodsScreenState extends State<ChooseGoodsScreen> {
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final controllerGood = Get.put(GoodRepository());
  final controllersortby = Get.put(ThemHangHoaController());
  String searchHangHoa = "";
  List<dynamic> allHangHoa = [];
  List<dynamic> filteredItems = [];

  bool isSelected = false; //  Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  List<bool> itemExpandedList = List.generate(200, (index) => false);
  String scannedCode = '';
  String selectedValue = 'Lẻ';
  List<dynamic> allHangHoaLe = [];
  List<dynamic> allHangHoaSi = [];
  List<dynamic> filteredItemsLe = [];
  List<dynamic> filteredItemsSi = [];

  Future<void> _showSortbyHangHoa() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return DanhSachSortByHangHoa(
          phanBietNhapXuat: widget.phanBietNhapXuat,
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

  @override
  void initState() {
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    allHangHoaLe = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán lẻ'))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Xác định hàng hóa bán lẻ
    allHangHoaLe = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán lẻ'))
        .toList();

    // Xác định hàng hóa bán sỉ
    allHangHoaSi = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán sỉ'))
        .toList();

    // Sắp xếp danh sách theo thứ tự tăng dần của "tonkho"
    controllerGood.sortby(
        allHangHoaLe, controllersortby.sortbyhanghoaController.text);
    controllerGood.sortby(
        allHangHoaSi, controllersortby.sortbyhanghoaController.text);

    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong lẻ
    filteredItemsLe = allHangHoaLe
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();

    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong sỉ
    filteredItemsSi = allHangHoaSi
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();

    if (selectedValue == 'Lẻ') {
      filteredItems = filteredItemsLe;
    } else {
      filteredItems = filteredItemsSi;
    }
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          title: Text("Chọn hàng hóa",
              style: TextStyle(fontSize: Font.sizes(context)[2])),
          backgroundColor: widget.phanBietNhapXuat == 1 ? blueColor : mainColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.079),
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
                        width: size.width * 0.7, //270
                      ),
                      IconButton(
                          onPressed: () {
                            _showSortbyHangHoa();
                          },
                          icon: Image(
                            image: const AssetImage(sortbyIcon),
                            height: size.width * 0.065, //27
                          )),
                      IconButton(
                        onPressed: () async {
                          scannedCode = await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", // Màu hiển thị của app
                            "Hủy bỏ", // Chữ hiển thị cho nút hủy bỏ
                            true, // Cho phép Async? (có hay không)
                            ScanMode.BARCODE, // Hình thức quét
                          );
                          if (!mounted) return;
                          if (scannedCode == "-1") {
                            // print('if hùy nè');
                          } else {
                            bool foundedItem = false;

                            for (var item in filteredItems) {
                              if (item['macode'] == scannedCode) {
                                foundedItem = true;
                                setState(() {});
                                break; // Thoát khỏi vòng lặp ngay khi tìm thấy sản phẩm
                              }
                            }

                            if (!foundedItem) {
                              // Nếu không tìm thấy sản phẩm, hiển thị SnackBar
                              SnackBarWidget.showSnackBar(context,
                                  "Không tìm thấy sản phẩm", cancel600Color);
                            }
                          }
                        },
                        icon: const ImageIcon(AssetImage(qRIcon)),
                        iconSize: size.width * 0.065,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15), // Đặt left padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phân loại: ',
                      style: TextStyle(fontSize: Font.sizes(context)[1]),
                    ),
                    DropdownButton<String>(
                      value: selectedValue,
                      items: <String>['Lẻ', 'Sỉ']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          if (selectedValue == 'Lẻ') {
                            filteredItems = filteredItemsLe;
                          } else {
                            filteredItems = filteredItemsSi;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final doc = filteredItems[index];
                  if (doc['macode'] == scannedCode) {
                    isSelected = true;
                    selectedDoc = doc;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = true;
                          selectedDoc = doc;
                          scannedCode = '';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: isSelected && selectedDoc == doc ? 2 : 1,
                              color: isSelected && selectedDoc == doc
                                  ? widget.phanBietNhapXuat == 1
                                      ? Colors.blue
                                      : mainColor // Màu border khi Container được chọn
                                  : Colors
                                      .black26, // Màu border khi Container không được chọn
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: doc["photoGood"].isEmpty
                                    ? Image(
                                        image: const AssetImage(hanghoaIcon),
                                        height: size.width * 0.07, //30
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          height: size.width * 0.07,
                                          width: size.width * 0.07,
                                          imageUrl: doc["photoGood"].toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc["tensanpham"],
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[1]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Kho: ${doc["tonkho"]} ${doc["donvi"]} - ",
                                            style: TextStyle(
                                                fontSize:
                                                    Font.sizes(context)[0],
                                                fontWeight: FontWeight.w100),
                                            textAlign: TextAlign.start,
                                          ),
                                          widget.phanBietNhapXuat == 1
                                              ? Text(
                                                  formatCurrency(
                                                      doc["gianhap"]),
                                                  style: TextStyle(
                                                      fontSize: Font.sizes(
                                                          context)[0],
                                                      fontWeight:
                                                          FontWeight.w100),
                                                  textAlign: TextAlign.start,
                                                )
                                              : Text(
                                                  formatCurrency(doc["giaban"]),
                                                  style: TextStyle(
                                                      fontSize: Font.sizes(
                                                          context)[0],
                                                      fontWeight:
                                                          FontWeight.w100),
                                                  textAlign: TextAlign.start,
                                                ),
                                        ],
                                      ),
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
                                        PhanCachWidget.dotLine(context),
                                        const SizedBox(height: 7),
                                        LocationWidget(hanghoa: doc)
                                      ],
                                    )
                                  : const SizedBox()
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
          height: size.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: size.width - 30,
                  height: size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          widget.phanBietNhapXuat == 1 ? blueColor : mainColor,
                      side: BorderSide(
                          color: widget.phanBietNhapXuat == 1
                              ? blueColor
                              : mainColor),
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
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: Font.sizes(context)[2]),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
