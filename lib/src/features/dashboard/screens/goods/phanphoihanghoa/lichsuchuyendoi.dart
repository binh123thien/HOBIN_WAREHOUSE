import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import 'widget/cardlichsuchuyendoi.dart';

class LichSuChuyenDoiScreen extends StatefulWidget {
  const LichSuChuyenDoiScreen({super.key});

  @override
  State<LichSuChuyenDoiScreen> createState() => _LichSuChuyenDoiScreenState();
}

class _LichSuChuyenDoiScreenState extends State<LichSuChuyenDoiScreen> {
  final chonHangHoaLeController = Get.put(ChonHangHoaLeController());
  //để lắng nghe dữ liệu thay đổi
  late List<dynamic> foundLichSu;
  @override
  void initState() {
    chonHangHoaLeController.loadAllLichSu();
    foundLichSu = chonHangHoaLeController.allLichSuCDFirebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: size.height * 0.6,
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
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
                const Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        child: const Text("Tìm",
                            style: TextStyle(fontSize: 17, color: mainColor)),
                        onPressed: () async {}))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
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
