import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/day_month.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/chart.dart';

import 'sliding_segmented_control.dart';

class ExpenseTrack extends StatefulWidget {
  const ExpenseTrack({super.key});

  @override
  State<ExpenseTrack> createState() => _ExpenseTrackState();
}

class _ExpenseTrackState extends State<ExpenseTrack> {
  int activeMonth = 4;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: whiteColor, boxShadow: [
            BoxShadow(color: whiteColor, spreadRadius: 0, blurRadius: 0)
          ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Tracking",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SlidingSegmentedControl(),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(months.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          activeMonth = index;
                        });
                      },
                      child: SizedBox(
                        width: (size.width - 40) / 7,
                        child: Column(
                          children: [
                            Text(
                              months[index]['label'],
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: activeMonth == index
                                    ? mainColor
                                    : whiteColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: activeMonth == index
                                        ? mainColor
                                        : Colors.black.withOpacity(0.3)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 7, 12, 7),
                                child: Center(
                                  child: Text(
                                    months[index]["day"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: activeMonth == index
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Doanh Thu",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "\$2123",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: size.width - 20,
                      height: 180,
                      child: LineChart(mainData()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
