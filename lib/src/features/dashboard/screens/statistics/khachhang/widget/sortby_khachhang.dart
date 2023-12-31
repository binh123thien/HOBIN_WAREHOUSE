import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/color.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';

class DanhSachSortByKhachHang extends StatefulWidget {
  final TextEditingController sortbykhachhangController;
  const DanhSachSortByKhachHang({
    super.key,
    required this.sortbykhachhangController,
  });

  @override
  State<DanhSachSortByKhachHang> createState() =>
      _DanhSachSortByKhachHangState();
}

final List sortbyList = [
  "Tất cả",
  "Khách hàng",
  "Nhà cung cấp",
  "Tên khách từ A=>Z",
  "Tên khách từ Z=>A"
];
String selectedSortType = "Tất cả";

class _DanhSachSortByKhachHangState extends State<DanhSachSortByKhachHang> {
  @override
  Widget build(BuildContext context) {
    final controllerSortby = Get.put(KhachHangController());
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.38,
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
                  controllerSortby.sortbyKhachHangController.text =
                      selectedSortType;
                  Navigator.of(context)
                      .pop(controllerSortby.sortbyKhachHangController.text);
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
