import 'package:flutter/material.dart';
import '../../../../../utils/utils.dart';

class CardItemBanHangDaChon extends StatelessWidget {
  final int phanbietNhapXuat;
  const CardItemBanHangDaChon({
    super.key,
    required this.hangHoaPicked,
    required this.sumItem,
    // required this.onUpdateSumItem,
    required this.phanbietNhapXuat,
  });

  final List<dynamic> hangHoaPicked;
  final int sumItem;
  // final void Function(int newSumItem) onUpdateSumItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hangHoaPicked.length,
            itemBuilder: (context, index) {
              var hanghoa = hangHoaPicked[index];
              if (hangHoaPicked.isNotEmpty) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.inventory_2,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hanghoa["tensp"],
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),
                                  //chia giá nhập xuất cho 2 trang
                                  Text(
                                    phanbietNhapXuat == 0
                                        ? formatCurrency(hanghoa["giaban"])
                                        : formatCurrency(hanghoa["gianhap"]),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Tồn kho: ${hanghoa["tonkho"]}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    'SL: ${hanghoa['soluong']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey, // Màu sắc nhạt
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Vị trí: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: '${hanghoa["location"]}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Ngày hết hạn: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: '${hanghoa["expire"]}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
