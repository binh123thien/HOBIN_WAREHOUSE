import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class ThongKeHangHoa extends StatelessWidget {
  const ThongKeHangHoa({
    super.key,
    required this.tonkho,
    required this.daban,
    required this.donvi,
  });
  final num tonkho;
  final num daban;
  final String donvi;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backGround600Color,
            ),
            height: 100,
            width: size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Text(
                "Thống kê",
                style: TextStyle(fontSize: 16, color: whiteColor),
              ),
            ),
          ),
          Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                width: size.width - 10,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tồn kho",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("$tonkho $donvi",
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Đã bán",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("$daban $donvi",
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
