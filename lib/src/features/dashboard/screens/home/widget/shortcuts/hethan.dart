import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

import '../../../../../../constants/color.dart';

class HetHanShortcutScreen extends StatefulWidget {
  const HetHanShortcutScreen({super.key});

  @override
  State<HetHanShortcutScreen> createState() => _HetHanShortcutScreenState();
}

class _HetHanShortcutScreenState extends State<HetHanShortcutScreen> {
  DateTime? startDate;
  DateTime? endDate;

  void _onTap() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: mainColor, // Set the background color here
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        startDate = pickedDateRange.start;
        endDate = pickedDateRange.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hết Hạn",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _onTap,
                        child: Container(
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: darkColor),
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                const Image(
                                  image: AssetImage(lichIcon),
                                  height: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  startDate != null && endDate != null
                                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                      : 'Chọn ngày...',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: mainColor,
                            side: const BorderSide(color: mainColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  7), // giá trị này xác định bán kính bo tròn
                            ),
                          ),
                          child: const Text(
                            'Tìm kiếm',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
