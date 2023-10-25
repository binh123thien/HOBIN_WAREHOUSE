import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/snackbar.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
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
  final controllerLocation = Get.put(GoodRepository());
  String searchHangHoa = "";
  List<dynamic> allHangHoa = [];
  List<dynamic> filteredItems = [];

  bool isSelected = false; //  Container đã được chọn hay chưa
  dynamic selectedDoc; // Biến để lưu trữ giá trị doc được chọn
  List<bool> itemExpandedList = List.generate(200, (index) => false);
  String scannedCode = '';

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
          backgroundColor: widget.phanBietNhapXuat == 1 ? blueColor : mainColor,
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
                        onPressed: () async {
                          scannedCode = await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", // Màu hiển thị của app
                            "Hủy bỏ", // Chữ hiển thị cho nút hủy bỏ
                            true, // Cho phép Async? (có hay không)
                            ScanMode.BARCODE, // Hình thức quét
                          );
                          if (!mounted) return;
                          if (scannedCode == "-1") {
                            print('if hùy nè');
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
                        iconSize: 30,
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
                                    Row(
                                      children: [
                                        Text(
                                          "Kho: ${doc["tonkho"]} ${doc["donvi"]} - ",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w100),
                                          textAlign: TextAlign.start,
                                        ),
                                        widget.phanBietNhapXuat == 1
                                            ? Text(
                                                formatCurrency(doc["gianhap"]),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w100),
                                                textAlign: TextAlign.start,
                                              )
                                            : Text(
                                                formatCurrency(doc["giaban"]),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w100),
                                                textAlign: TextAlign.start,
                                              ),
                                      ],
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
