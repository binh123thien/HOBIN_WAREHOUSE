import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';

class DanhSachSortByHangHoa extends StatefulWidget {
  final TextEditingController sortbyhanghoaController;
  final int phanBietNhapXuat;
  const DanhSachSortByHangHoa(
      {super.key,
      required this.sortbyhanghoaController,
      required this.phanBietNhapXuat});

  @override
  State<DanhSachSortByHangHoa> createState() => _DanhSachSortByHangHoaState();
}

final List sortbyList = [
  "Giá tăng dần",
  "Giá giảm dần",
  "Tồn kho tăng dần",
  "Tồn kho giảm dần",
  "Đã bán tăng dần",
  "Đã bán giảm dần"
];
String selectedSortType = "Giá tăng dần";

class _DanhSachSortByHangHoaState extends State<DanhSachSortByHangHoa> {
  final controller = Get.put(ThemHangHoaController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sắp xếp theo"),
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
                  controller.sortbyhanghoaController.text = selectedSortType;
                  Navigator.of(context)
                      .pop(controller.sortbyhanghoaController.text);
                });
              },
              child: Container(
                width: size.width,
                height: 45,
                color: isSelected
                    ? (widget.phanBietNhapXuat == 0 ? mainColor : blueColor)
                    : Colors.transparent,
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
