import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';
import 'widget/add_location.dart';
import 'widget/add_quantity.dart';

class CardNhapHangShowMore extends StatefulWidget {
  final int phanBietNhapXuat;
  final dynamic hanghoa;
  const CardNhapHangShowMore({
    super.key,
    this.hanghoa,
    required this.phanBietNhapXuat,
  });

  @override
  State<CardNhapHangShowMore> createState() => _CardNhapHangShowMoreState();
}

class _CardNhapHangShowMoreState extends State<CardNhapHangShowMore> {
  final conntrollerGood = Get.put(GoodRepository());
  List<Map<String, dynamic>> dataMapList = [];

  @override
  void initState() {
    super.initState();
    conntrollerGood
        .getAllLocation(widget.hanghoa["macode"])
        .listen((QuerySnapshot snapshot) {
      setState(() {
        List<Map<String, dynamic>> tempList =
            List.from(dataMapList); // Tạo danh sách tạm thời

        for (var doc in snapshot.docs) {
          String location = doc['location'];
          String expiration = doc['exp'];
          Map<String, dynamic> dataMap = {
            'tensp': widget.hanghoa["tensanpham"],
            'location': location,
            'exp': expiration,
            'soluong': 0,
          };

          tempList.add(dataMap);
        }

        dataMapList = tempList; // Cập nhật dataMapList thành danh sách tạm thời
      });
    });
  }

  Future<void> updateExpirationDate(int index, String newDate) async {
    setState(() {
      dataMapList[index]["exp"] = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build card ${conntrollerGood.listNhapXuathang}');
    Future<void> addLocation() async {
      await showModalBottomSheet<num>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return AddLocation(
            phanBietNhapXuat: widget.phanBietNhapXuat,
            hanghoa: widget.hanghoa,
          );
        },
      );
    }

    Future<void> addQuantity() async {
      await showModalBottomSheet<num>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return const AddQuantity();
        },
      );
    }

    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12), // Đặt bán kính bo góc tại đây
              color: whiteColor,
            ),
            child: ExpansionPanelList(
              elevation: 1, // Độ nâng của ExpansionPanelList
              expandedHeaderPadding: EdgeInsets
                  .zero, // Khoảng cách giữa tiêu đề và nội dung được mở rộng
              expansionCallback: (int panelIndex, bool isExpanded) {
                setState(() {
                  conntrollerGood.expandShowMore.value = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      textColor:
                          widget.phanBietNhapXuat == 0 ? mainColor : blueColor,
                      leading: widget.hanghoa["photoGood"].isEmpty
                          ? const Image(
                              image: AssetImage(hanghoaIcon),
                              height: 35,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                imageUrl:
                                    widget.hanghoa["photoGood"].toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                      title: Text(
                        widget.hanghoa["tensanpham"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      trailing: SizedBox(
                        width: 65,
                        height: 25,
                        child: ElevatedButton(
                          onPressed: () {
                            addLocation();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: widget.phanBietNhapXuat == 1
                                ? blueColor
                                : mainColor,
                            side: BorderSide(
                                color: widget.phanBietNhapXuat == 1
                                    ? blueColor
                                    : mainColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // giá trị này xác định bán kính bo tròn
                            ),
                          ),
                          child: const Text(
                            'Nhập',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "Kho: ${widget.hanghoa["tonkho"]} ${widget.hanghoa["donvi"]} - ${widget.phanBietNhapXuat == 1 ? formatCurrency(widget.hanghoa["gianhap"]) : formatCurrency(widget.hanghoa["giaban"])}",
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w100),
                        textAlign: TextAlign.start,
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey, // Màu nền mong muốn
                          ),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FixedColumnWidth(120), // Location column width
                              1: FixedColumnWidth(100), // SL column width
                              2: FixedColumnWidth(120), // Exp column width
                            },
                            children: const [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Vị trí',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text('Số lượng',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text('Ngày hết hạn',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...conntrollerGood.listNhapXuathang
                            .where((element) =>
                                widget.hanghoa['macode'] == element['macode'])
                            .toList()
                            .map((document) {
                          var location = document['location'];
                          var soluong = document['soluong'];
                          var expire = document['expire'];
                          return Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FixedColumnWidth(120), // Location column width
                              1: FixedColumnWidth(100), // SL column width
                              2: FixedColumnWidth(120), // Exp column width
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        location,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        soluong.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        expire.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  isExpanded: conntrollerGood
                      .expandShowMore.value, // Cập nhật giá trị mở rộng
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
