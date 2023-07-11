import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';

class LichSuChuyenDoiScreen extends StatefulWidget {
  const LichSuChuyenDoiScreen({super.key});

  @override
  State<LichSuChuyenDoiScreen> createState() => _LichSuChuyenDoiScreenState();
}

class _LichSuChuyenDoiScreenState extends State<LichSuChuyenDoiScreen> {
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
                Expanded(
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
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: foundDonVi.length,
            //     itemBuilder: (context, index) {
            //       final donvi = foundDonVi[index];
            //       return Dismissible(
            //         key: Key(donvi),
            //         // direction: DismissDirection.endToStart,
            //         onDismissed: (direction) {
            //           print('không cho auto xóa');
            //         },
            //         confirmDismiss: (direction) async {
            //           MyDialog.showAlertDialog(
            //               context, 'Xác nhận', "Bạn có muốn xóa ?", () {
            //             chonDonViController.deleteDonviByTen(donvi);
            //             Navigator.of(context).pop();
            //             Navigator.of(context).pop();
            //           });
            //           return null;
            //         },
            //         background: Container(
            //           color: Colors.red,
            //           padding: const EdgeInsets.symmetric(horizontal: 20),
            //           alignment: AlignmentDirectional.centerEnd,
            //           child: const Icon(Icons.delete, color: Colors.white),
            //         ),
            //         child: SizedBox(
            //           width: size.width,
            //           height: 50,
            //           child: Card(
            //             child: GestureDetector(
            //               onTap: () {
            //                 // Xử lý khi người dùng nhấn vào
            //                 Navigator.of(context).pop(donvi);
            //               },
            //               child: Center(
            //                 child: Text(
            //                   donvi,
            //                   style: const TextStyle(fontSize: 18),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
