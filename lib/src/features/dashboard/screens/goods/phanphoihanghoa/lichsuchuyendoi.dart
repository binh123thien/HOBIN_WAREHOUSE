import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import 'widget/cardlichsuchuyendoi.dart';

class LichSuChuyenDoiScreen extends StatefulWidget {
  final String nameProductSi;
  const LichSuChuyenDoiScreen({super.key, required this.nameProductSi});

  @override
  State<LichSuChuyenDoiScreen> createState() => _LichSuChuyenDoiScreenState();
}

class _LichSuChuyenDoiScreenState extends State<LichSuChuyenDoiScreen> {
  final chonHangHoaLeController = Get.put(ChonHangHoaLeController());
  //để lắng nghe dữ liệu thay đổi
  late List<dynamic> foundLichSu;
  @override
  void initState() {
    chonHangHoaLeController.loadAllLichSu(widget.nameProductSi);
    foundLichSu = chonHangHoaLeController.allLichSuCDFirebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //hàm tìm kiếm lịch sử
    void search(String keyword) {
      setState(() {
        foundLichSu = chonHangHoaLeController.allLichSuCDFirebase
            .where((lichsu) =>
                lichsu['ngaytao']
                    .toString()
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                lichsu['tenSanPhamLe']
                    .toString()
                    .toLowerCase()
                    .contains(keyword.toLowerCase()))
            //     ||
            // lichsu['soluongSi']
            //     .toString()
            //     .toLowerCase()
            //     .contains(keyword.toLowerCase()) ||
            // lichsu['soluongLe']
            //     .toString()
            //     .toLowerCase()
            //     .contains(keyword.toLowerCase()) ||
            // lichsu['chuyendoiLe']
            //     .toString()
            //     .toLowerCase()
            //     .contains(keyword.toLowerCase()) ||
            // lichsu['chuyendoiSi']
            //     .toString()
            //     .toLowerCase()
            //     .contains(keyword.toLowerCase()) ||
            // lichsu['tenSanPhamSi']
            //     .toString()
            //     .toLowerCase()
            //     .contains(keyword.toLowerCase())
            .toList();
      });
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: size.height * 0.6,
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 20),
        child: Column(
          children: [
            const Divider(
              // thêm Divider
              height: 1,
              thickness: 5,
              color: backGroundColor,
              indent: 120,
              endIndent: 120,
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Lịch sử chuyển đổi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -10,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_rounded)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SearchWidget(
                  onChanged: (value) {
                    search(value);
                  },
                  width: 320,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: foundLichSu.isEmpty
                  ? const Center(child: Text("Chưa có lịch sử chuyển đổi"))
                  : ListView.builder(
                      itemCount: foundLichSu.length,
                      itemBuilder: (context, index) {
                        var lichsu = foundLichSu[index];
                        return Cardlichsuchuyendoi(
                          lichsu: lichsu,
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
