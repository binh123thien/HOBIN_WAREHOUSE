import 'package:flutter/material.dart';
import '../../../../../../constants/image_strings.dart';

class Cardlichsuchuyendoi extends StatelessWidget {
  const Cardlichsuchuyendoi({
    super.key,
    required this.lichsu,
  });

  final dynamic lichsu;
  @override
  Widget build(BuildContext context) {
    int tongchuyendoi = lichsu['chuyendoiLe'] * lichsu['chuyendoiSi'];
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lichsu['ngaytao'], style: const TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lichsu['tenSanPhamSi'],
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Text(
                    lichsu['soluongSi'].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.south_outlined,
                    color: Colors.red,
                    size: 14,
                  ),
                  Text(
                    lichsu['chuyendoiSi'].toString(),
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    chuyendoiImage,
                    width: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    lichsu['tenSanPhamLe'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    lichsu['soluongLe'].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_upward_outlined,
                    color: Colors.green,
                    size: 14,
                  ),
                  Text(
                    tongchuyendoi.toString(),
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
