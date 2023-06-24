import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

List<Color> gradientColors = [mainColor];

LineChartData mainData() {
  return LineChartData(
      //Background khi nhan vao hiện thông tin
      lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: backGroundColor,
          )),
      //Set màu va độ đậm của line dữ liệu
      gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: mainColor,
              strokeWidth: 0.1,
            );
          }),
      //Set title dữ liệu (bên dưới và bên phải)
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: (value, meta) {
              String text = '';
              switch (value.toInt()) {
                case 2:
                  text = "Mon";
                  break;
                case 3:
                  text = "Tue";
                  break;
                case 4:
                  text = "Wed";
                  break;
                case 5:
                  text = "Thu";
                  break;
                case 6:
                  text = "Fri";
                  break;
                case 7:
                  text = "Sat";
                  break;
                case 8:
                  text = "Sun";
                  break;
              }
              return Text(
                text,
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 80,
            getTitlesWidget: (value, meta) {
              String text = '';
              switch (value.toInt()) {
                case 200:
                  text = "200k";
                  break;
                case 400:
                  text = "400k";
                  break;
                case 600:
                  text = "600k";
                  break;
                case 800:
                  text = "800k";
                  break;
                case 1000:
                  text = "100k";
                  break;
              }
              return Text(
                text,
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 2,
      maxX: 8,
      minY: 0,
      maxY: 1000,
      lineBarsData: [
        LineChartBarData(
            spots: const [
              FlSpot(2, 102),
              FlSpot(3, 53),
              FlSpot(4, 209),
              FlSpot(5, 423),
              FlSpot(6, 687),
              FlSpot(7, 123),
              FlSpot(8, 2),
            ],
            isCurved: true,
            color: mainColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ))
      ]);
}
