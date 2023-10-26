import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
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
      height: size.height * 0.31,
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
                  controllerKhachHang.sortbyDonNoController.text =
                      selectedSortType;
                  Navigator.of(context)
                      .pop(controllerKhachHang.sortbyDonNoController.text);
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
