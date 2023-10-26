import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';

class SortByKhachNo extends StatefulWidget {
  final TextEditingController sortbyKhachNoController;
  const SortByKhachNo({
    super.key,
    required this.sortbyKhachNoController,
  });

  @override
  State<SortByKhachNo> createState() => _SortByKhachNoState();
}

final List sortbyList = [
  "Khách Hàng",
  "Nhà Cung Cấp",
  "Nợ tăng dần",
  "Nợ giảm dần",
  "A=>Z",
  "Z=>A",
];
String selectedSortType = "Nợ tăng dần";

class _SortByKhachNoState extends State<SortByKhachNo> {
  @override
  Widget build(BuildContext context) {
    String selectedSortType = widget.sortbyKhachNoController.text;
    final controllerKhachHang = Get.put(KhachHangController());
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.42,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phân loại",
                style: TextStyle(fontSize: Font.sizes(context)[2]),
              ),
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
                  controllerKhachHang.sortbyKhachNoController.text =
                      selectedSortType;
                  Navigator.of(context)
                      .pop(controllerKhachHang.sortbyKhachNoController.text);
                });
              },
              child: Container(
                width: size.width,
                height: size.height * 0.055,
                color: isSelected ? mainColor : Colors.transparent,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      sortType,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: Font.sizes(context)[2]),
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
