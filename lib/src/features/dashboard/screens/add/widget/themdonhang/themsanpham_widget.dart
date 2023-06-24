import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';

class ThemSanPhamWidget extends StatelessWidget {
  final int phanbietNhapXuat;
  const ThemSanPhamWidget({
    super.key,
    required this.onPressed,
    required this.onPressedScan,
    required this.phanbietNhapXuat,
  });
  final VoidCallback onPressed;
  final VoidCallback onPressedScan;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: phanbietNhapXuat == 0 ? mainColor : blueColor,
            ),
            width: size.width,
            height: 85,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Text(
                "Danh sách sản phẩm",
                style: TextStyle(fontSize: 16, color: whiteColor),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteColor,
              ),
              width: size.width - 10,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          side: const BorderSide(
                              color: success600Color, width: 2),
                          fixedSize: const Size.fromHeight(40),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        ),
                        onPressed: onPressed,
                        child: const Text(
                          "Thêm sản phẩm",
                          style:
                              TextStyle(color: success600Color, fontSize: 18),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: onPressedScan,
                            icon:
                                const ImageIcon(AssetImage(qRIcon), size: 30)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
