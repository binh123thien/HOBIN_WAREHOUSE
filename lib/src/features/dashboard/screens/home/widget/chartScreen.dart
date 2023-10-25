import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/statistics/doanhthu_controller.dart';

import 'bar_graph/bar_graph.dart';

class ChartScreen extends StatefulWidget {
  final String selectedWeek;
  const ChartScreen({super.key, required this.selectedWeek});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final DoanhThuController doanhThuControllerRepo = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<double>>(
      stream: doanhThuControllerRepo
          .getDoanhThu7DayFromFirebase(widget.selectedWeek),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          var document = snapshot.data!;
          if (document.isEmpty) {
            document = [0, 0, 0, 0, 0, 0, 0];
          }
          //tim gia tri lon nhat trong chart truyen vao bargraph
          double maxElement = document
              .reduce((value, element) => value > element ? value : element);
          if (maxElement == 0) {
            maxElement = 100;
          }
          return SizedBox(
            height: size.height * 0.23,
            child: BarGraph(
              maxElement: maxElement,
              weeklySummary: document,
            ),
          );
        }
      },
    );
  }
}
