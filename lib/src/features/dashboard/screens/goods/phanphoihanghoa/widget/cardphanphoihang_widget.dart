import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPhanPhoiHang extends StatelessWidget {
  const CardPhanPhoiHang({
    super.key,
    required this.donViProduct,
    required this.imageProduct,
    required this.updatehanghoa,
    required this.slchuyendoi,
    required this.phanBietSiLe,
    required this.soluong,
    this.locationSiGanNhat,
    this.listPickedLocationLe,
  });
  final List<Map<String, dynamic>>? listPickedLocationLe;
  final Map<String, dynamic>? locationSiGanNhat;
  //set màu cho tăng giảm card trang done
  final RxInt soluong;
  final bool phanBietSiLe;
  final int slchuyendoi;
  final String imageProduct;
  final String donViProduct;
  final dynamic updatehanghoa;
  @override
  Widget build(BuildContext context) {
    print('list le picked $listPickedLocationLe');
    List<Map<String, dynamic>> listTable = [];
    if (locationSiGanNhat != null) {
      listTable.add(locationSiGanNhat!);
    }
    if (listPickedLocationLe != null) {
      listTable.addAll(listPickedLocationLe!);
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Obx(
        () {
          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      updatehanghoa['photoGood'].isEmpty
                          ? Image(
                              image: AssetImage(imageProduct),
                              height: 35,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: updatehanghoa['photoGood'].toString(),
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                      const Padding(padding: EdgeInsets.only(left: 7)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            updatehanghoa['tensanpham'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Tồn kho: ',
                                style: TextStyle(fontSize: 15),
                              ),
                              // lấy soluong cho trang done
                              (soluong != 0)
                                  ? Text(soluong.toString(),
                                      style: const TextStyle(fontSize: 15))
                                  : Text(updatehanghoa['tonkho'].toString(),
                                      style: const TextStyle(fontSize: 15)),
                              Text(' $donViProduct  ',
                                  style: const TextStyle(fontSize: 15)),
                              //lấy slchuyendoi cho trang done
                              (slchuyendoi != 0)
                                  ? Row(
                                      children: [
                                        phanBietSiLe
                                            ? const Icon(
                                                Icons.south_outlined,
                                                color: Colors.red,
                                                size: 14,
                                              )
                                            : const Icon(
                                                Icons.arrow_upward_outlined,
                                                color: Colors.green,
                                                size: 14,
                                              ),
                                        phanBietSiLe
                                            ? Text(
                                                '$slchuyendoi',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              )
                                            : Text(
                                                '$slchuyendoi',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green),
                                              ),
                                      ],
                                    )
                                  : const Text('')
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                          for (var doc in listTable)
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
