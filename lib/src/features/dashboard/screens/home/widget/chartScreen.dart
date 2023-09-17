import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/bar_graph/bar_graph.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<double> weeklySummary = [
    200,
    300,
    256,
    110,
    330,
    500,
    210,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: BarGraph(
        weeklySummary: weeklySummary,
      ),
    );
  }
}
