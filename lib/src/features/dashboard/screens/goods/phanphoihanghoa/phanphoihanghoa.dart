import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/widget/location_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/chonhanghoale.dart';

import '../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../controllers/add/chonhanghoa_controller.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import '../../../controllers/goods/them_hanghoa_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import '../widget/sorbyhanghoa/danhsach_sortby.dart';
import 'lichsuchuyendoi.dart';

class PhanPhoiHangHoaScreen extends StatefulWidget {
  final dynamic hanghoaSi;
  const PhanPhoiHangHoaScreen({super.key, this.hanghoaSi});

  @override
  State<PhanPhoiHangHoaScreen> createState() => _PhanPhoiHangHoaScreenState();
}

class _PhanPhoiHangHoaScreenState extends State<PhanPhoiHangHoaScreen> {
  late dynamic updatehanghoaSi;
  String searchHangHoa = "";
  //tạo list hangHoaLe
  late List<dynamic> allHangHoa = [];
  // ========================== sorrt by ======================
  final controllersortby = Get.put(ThemHangHoaController());
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final controllerGoodRepo = Get.put(GoodRepository());
  final chonHangHoaLeController = Get.put(ChonHangHoaLeController());

  bool isSelected = false;
  dynamic selectedDoc;
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

  //===================== end sort by ==========================================================
  List<bool> itemExpandedList = List.generate(200, (index) => false);
  @override
  void initState() {
    //load trước dữ liệu của list lịch sử
    chonHangHoaLeController.loadAllLichSu(widget.hanghoaSi['tensanpham']);
    updatehanghoaSi = widget.hanghoaSi;
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('thong tin hang hoa si ${widget.hanghoaSi}');
    // bottom sheet lịch sử
    Future<void> showLichSuChuyenDoi() async {
      await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return LichSuChuyenDoiScreen(
            nameProductSi: updatehanghoaSi['tensanpham'],
          ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
        },
      );
    }

    // Xác định hàng hóa bán sỉ
    List<dynamic> allHangHoaLe = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán lẻ'))
        .toList();
    // Sắp xếp danh sách theo thứ tự tăng dần của "tonkho"
    controllerGoodRepo.sortby(
        allHangHoaLe, controllersortby.sortbyhanghoaController.text);
    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong sỉ
    List<dynamic> filteredItemsLe = allHangHoaLe
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text("Phân phối hàng hóa",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
          backgroundColor: backGroundColor,
          centerTitle: true,
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: () {
                showLichSuChuyenDoi();
              },
              icon: const Image(
                image: AssetImage(historyShareGoodIcon),
                height: 25,
              ),
            ),
            IconButton(
              color: Colors.black,
              onPressed: () {
                MyDialog.showAlertDialogOneBtn(context, "Hướng dẫn",
                    "  Việc phân phối hàng hóa giúp bạn chia sản phẩm sỉ ra thành sản phẩm lẻ. Điều này giúp bạn dễ dàng kiểm soát được lượng hàng bán lẻ.\n\nVD: 1 Thùng = 24 lon");
              },
              icon: const Image(
                image: AssetImage(warningIcon),
                height: 25,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SearchWidget(
                        onChanged: (value) {
                          setState(() {
                            searchHangHoa = value;
                          });
                        },
                        width: 310,
                      ),
                      IconButton(
                          onPressed: () {
                            _showSortbyHangHoa();
                          },
                          icon: const Image(image: AssetImage(sortbyIcon))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Đang chọn: ${updatehanghoaSi['tensanpham']}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      )),
                  if (controllerGoodRepo.listLocationHangHoaSi.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Mời bạn nhập thêm hàng',
                          style: TextStyle(
                              fontSize: 20,
                              color: mainColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        width: 350,
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1.1), // Cột Vị trí
                            1: FlexColumnWidth(1.0), // Cột Hết hạn
                            2: FlexColumnWidth(0.7), // Cột SL
                          },
                          children: <TableRow>[
                            const TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text('Vị trí',
                                        style: TextStyle(fontSize: 17)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text('Hết hạn',
                                        style: TextStyle(fontSize: 17)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text('SL',
                                        style: TextStyle(fontSize: 17)),
                                  ),
                                ),
                              ],
                            ),
                            // Tạo các hàng dữ liệu
                            for (var doc
                                in controllerGoodRepo.listLocationHangHoaSi)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(doc['location'],
                                          style: const TextStyle(fontSize: 17)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(doc['exp'],
                                          style: const TextStyle(fontSize: 17)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(doc['soluong'].toString(),
                                          style: const TextStyle(fontSize: 17)),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 3),
                  const Text('Mặt hàng muốn phân phối:',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width,
                    height: size.height - 230,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        physics: const PageScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredItemsLe.length,
                        itemBuilder: (context, index) {
                          var doc = filteredItemsLe[index];
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
                                      width: isSelected && selectedDoc == doc
                                          ? 2
                                          : 1,
                                      color: isSelected && selectedDoc == doc
                                          ? mainColor // Màu border khi Container được chọn
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
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  imageUrl: doc["photoGood"]
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(doc["tensanpham"]),
                                            Row(
                                              children: [
                                                Text(
                                                  "Kho: ${doc["tonkho"]} ${doc["donvi"]}",
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                      backgroundColor: mainColor,
                      side: const BorderSide(color: mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // giá trị này xác định bán kính bo tròn
                      ),
                    ),
                    onPressed: selectedDoc != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChonHangHoaLeScreen(
                                        hanghoaLe: selectedDoc,
                                        hanghoaSi: updatehanghoaSi,
                                      )),
                            );
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
