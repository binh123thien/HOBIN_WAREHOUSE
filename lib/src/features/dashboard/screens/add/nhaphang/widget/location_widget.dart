import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../repository/goods_repository/good_repository.dart';

class LocationWidget extends StatefulWidget {
  final dynamic hanghoa;
  const LocationWidget({Key? key, this.hanghoa}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final StreamController<List<Map<String, dynamic>>>
      _locationDataStreamController =
      StreamController<List<Map<String, dynamic>>>();
  final conntrollerGood = Get.put(GoodRepository());
  @override
  void dispose() {
    _locationDataStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Gọi hàm getLocationData và lắng nghe sự thay đổi của dữ liệu
    _getLocationData();
  }

  Future<void> _getLocationData() async {
    String macode = widget.hanghoa["macode"];
    List<Map<String, dynamic>> locationData =
        await conntrollerGood.getLocationData(macode);
    _locationDataStreamController.sink.add(locationData);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _locationDataStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Bạn chưa có dữ liệu');
        } else {
          List<Map<String, dynamic>> dataMapList = [];

          for (var doc in snapshot.data ?? []) {
            Map<String, dynamic> dataMap = {
              'location': doc['location'],
              'exp': doc['exp'],
              'soluong': doc['soluong'],
            };
            dataMapList.add(dataMap);
          }
          final dateFormatter = DateFormat("dd/MM/yyyy");

          dataMapList.sort((a, b) {
            final aExpDate = dateFormatter.parseStrict(a["exp"]);
            final bExpDate = dateFormatter.parseStrict(b["exp"]);
            return aExpDate.compareTo(bExpDate);
          });
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
        }
      },
    );
  }
}
