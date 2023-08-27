import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';
import 'widget/add_location.dart';
import 'widget/add_quantity.dart';

class CardNhapHangShowMore extends StatefulWidget {
  final int phanbietNhapXuat;
  final dynamic hanghoa;
  const CardNhapHangShowMore({
    super.key,
    this.hanghoa,
    required this.phanbietNhapXuat,
  });

  @override
  State<CardNhapHangShowMore> createState() => _CardNhapHangShowMoreState();
}

class _CardNhapHangShowMoreState extends State<CardNhapHangShowMore> {
  bool isExpanded = false;
  final conntroller = Get.put(GoodRepository());
  List<Map<String, dynamic>> dataMapList = [];

  @override
  void initState() {
    super.initState();
    conntroller
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: whiteColor,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
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
                    imageUrl: widget.hanghoa["photoGood"].toString(),
                    fit: BoxFit.fill,
                  ),
                ),
          title: Text(
            widget.hanghoa["tensanpham"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                backgroundColor:
                    widget.phanbietNhapXuat == 0 ? mainColor : blueColor,
                side: BorderSide(
                  color: widget.phanbietNhapXuat == 0 ? mainColor : blueColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // giá trị này xác định bán kính bo tròn
                ),
              ),
              child: const Text(
                'Thêm',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          subtitle: Text(
            "Kho: ${widget.hanghoa["tonkho"]} ${widget.hanghoa["donvi"]} - ${formatCurrency(widget.hanghoa["giaban"])}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
            textAlign: TextAlign.start,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: conntroller.getAllLocation(widget.hanghoa["macode"]),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Không có dữ liệu"));
                    } else {
                      return Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FixedColumnWidth(90), // Location column width
                          1: FixedColumnWidth(70), // SL column width
                          2: FixedColumnWidth(105), // Exp column width
                          3: FixedColumnWidth(80), // Nhập column width
                        },
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text(
                                    'Location',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text('SL',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text('Exp',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text('Nhập',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(snapshot.data!.docs.length, (index) {
                            var document = snapshot.data!.docs[index];
                            var location = document['location'];
                            var soluong = document['soluong'];

                            return TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: Text(location,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: Text(soluong.toString(),
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: InkWell(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2030),
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            String newDate =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(selectedDate);
                                            updateExpirationDate(
                                                index, newDate);
                                          }
                                        });
                                      },
                                      child: Text(
                                        dataMapList[index]["exp"].isEmpty
                                            ? "Date"
                                            : dataMapList[index]["exp"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: dataMapList[index]["exp"]
                                                    .isEmpty
                                                ? blueColor
                                                : cancel600Color),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: InkWell(
                                      onTap: () {
                                        addQuantity();
                                      },
                                      child: const Text(
                                        "Chọn",
                                        style: TextStyle(
                                            fontSize: 16, color: blueColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
