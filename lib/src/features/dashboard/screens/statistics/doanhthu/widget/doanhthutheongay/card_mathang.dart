import 'package:flutter/material.dart';

import '../../../../../../../utils/utils.dart';

class CardMatHang extends StatelessWidget {
  const CardMatHang({super.key, required this.docs});
  final List<dynamic> docs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Text("Tên hàng hóa", style: TextStyle(fontSize: 15))),
              Expanded(
                  flex: 1,
                  child: Text("Đã bán", style: TextStyle(fontSize: 15))),
              Expanded(
                  flex: 3,
                  child: Text(
                    "D.Thu ước tính",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.right,
                  )),
            ],
          ),
          const Divider(),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];

                return Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              doc.keys.first,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(doc.values.first.toString(),
                                style: const TextStyle(fontSize: 17)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              formatCurrency(doc["giaBan"] * doc.values.first),
                              style: const TextStyle(fontSize: 17),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ]),
                    const Divider()
                  ],
                );
              }),
        ],
      ),
    );
  }
}
