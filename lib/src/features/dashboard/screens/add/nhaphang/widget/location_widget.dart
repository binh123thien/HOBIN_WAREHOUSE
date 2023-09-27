import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../repository/goods_repository/good_repository.dart';

class LocationWidget extends StatefulWidget {
  final dynamic hanghoa;
  const LocationWidget({Key? key, this.hanghoa}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final conntrollerGood = Get.put(GoodRepository());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: conntrollerGood.getAllLocation(widget.hanghoa["macode"]),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị một tiêu đề hoặc tiêu đề tải dữ liệu khi đang chờ
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Center(
            child: Text("Đã xảy ra lỗi: ${snapshot.error}"),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Lấy dữ liệu từ snapshot và cập nhật dataMapList
          List<Map<String, dynamic>> dataMapList = [];
          for (var doc in snapshot.data!.docs) {
            String location = doc['location'];
            String expiration = doc['exp'];
            Map<String, dynamic> dataMap = {
              'location': location,
              'exp': expiration,
              'soluong': doc["soluong"],
            };
            dataMapList.add(dataMap);
          }

          // Hiển thị bảng Table với dữ liệu mới
          return SizedBox(
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
                        child: Text('Vị trí', style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('Hết hạn', style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('SL', style: TextStyle(fontSize: 17)),
                      ),
                    ),
                  ],
                ),
                // Tạo các hàng dữ liệu
                for (var doc in dataMapList)
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
          );
        } else {
          // Hiển thị thông báo khi không có dữ liệu
          return const Center(
            child: Text("Không có vị trí.", style: TextStyle(fontSize: 17)),
          );
        }
      },
    );
  }
}
