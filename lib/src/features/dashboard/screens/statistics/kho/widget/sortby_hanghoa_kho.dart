import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../controllers/goods/sortby_controller.dart';

class DanhSachSortByHangHoaKho extends StatefulWidget {
  final TextEditingController sortbyHangHoaKhoController;
  const DanhSachSortByHangHoaKho({
    super.key,
    required this.sortbyHangHoaKhoController,
  });

  @override
  State<DanhSachSortByHangHoaKho> createState() =>
      _DanhSachSortByHangHoaKhoState();
}

final List sortbyList = [
  "Tồn kho tăng dần",
  "Tồn kho giảm dần",
  "Đã bán tăng dần",
  "Đã bán giảm dần",
  "A => Z",
  "Z => A",
];
String selectedSortType = "Tồn kho tăng dần";

class _DanhSachSortByHangHoaKhoState extends State<DanhSachSortByHangHoaKho> {
  @override
  Widget build(BuildContext context) {
    final controllerSortby = Get.put(SortbyHangHoaController());
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.45,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Phân loại"),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel_rounded))
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: sortbyList.length,
          itemBuilder: (BuildContext context, int index) {
            final sortType = sortbyList[index];

            // Kiểm tra xem có phải phần tử được chọn hay không
            bool isSelected = selectedSortType == sortType;

            return InkWell(
              onTap: () {
                // Cập nhật giá trị và màu nền khi người dùng chọn phần tử khác
                setState(() {
                  selectedSortType = sortType;
                  controllerSortby.sortbyHangHoaKhoController.text =
                      selectedSortType;
                  Navigator.of(context)
                      .pop(controllerSortby.sortbyHangHoaKhoController.text);
                });
              },
              child: Container(
                width: size.width,
                height: 45,
                color: isSelected ? mainColor : Colors.transparent,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      sortType,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 19),
                    ),
                  ),
                ),
              ),
            );
          },
        ))
      ]),
    );
  }
}
