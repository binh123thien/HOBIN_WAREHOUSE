import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import 'bar_data.dart';

class BarGraph extends StatefulWidget {
  final List weeklySummary;
  const BarGraph({super.key, required this.weeklySummary});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        monAmount: widget.weeklySummary[0],
        tueAmount: widget.weeklySummary[1],
        wedAmount: widget.weeklySummary[2],
        thurAmount: widget.weeklySummary[3],
        friAmount: widget.weeklySummary[4],
        satAmount: widget.weeklySummary[5],
        sunAmount: widget.weeklySummary[6]);
    myBarData.initializeBarData();
    return BarChart(
      BarChartData(
          maxY: 500,
          minY: 0,
          barTouchData: BarTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: whiteColor,
                  tooltipBorder: const BorderSide(color: darkColor))),
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTitles)),
          ),
          barGroups: myBarData.barData
              .map(
                (data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: mainColor,
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, toY: 500, color: backGroundColor))
                ]),
              )
              .toList()),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "M",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "T",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "W",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "Th",
        style: style,
      );
      break;
    case 4:
      text = const Text(
        "Fr",
        style: style,
      );
      break;
    case 5:
      text = const Text(
        "Sa",
        style: style,
      );
      break;
    case 6:
      text = const Text(
        "Su",
        style: style,
      );
      break;
    default:
      text = const Text(
        "",
        style: style,
      );
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
