import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';

class SortByDonNo extends StatefulWidget {
  final TextEditingController sortbyDonNoController;
  const SortByDonNo({
    super.key,
    required this.sortbyDonNoController,
  });

  @override
  State<SortByDonNo> createState() => _SortByDonNoState();
}

final List sortbyList = [
  "Khách Hàng",
  "Nhà Cung Cấp",
  "Nợ tăng dần",
  "Nợ giảm dần",
];

class _SortByDonNoState extends State<SortByDonNo> {
  @override
  Widget build(BuildContext context) {
    String selectedSortType = widget.sortbyDonNoController.text;
    final controllerKhachHang = Get.put(KhachHangController());
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
                  controllerKhachHang.sortbyDonNoController.text =
                      selectedSortType;
                  Navigator.of(context)
                      .pop(controllerKhachHang.sortbyDonNoController.text);
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
