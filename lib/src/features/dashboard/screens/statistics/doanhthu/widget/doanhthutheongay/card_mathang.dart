import 'package:flutter/material.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Text("Tên hàng hóa",
                      style: TextStyle(fontSize: Font.sizes(context)[0]))),
              Expanded(
                  flex: 1,
                  child: Text("Đã bán",
                      style: TextStyle(fontSize: Font.sizes(context)[0]))),
              Expanded(
                  flex: 3,
                  child: Text(
                    "D.Thu ước tính",
                    style: TextStyle(fontSize: Font.sizes(context)[0]),
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
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(doc.values.first.toString(),
                                style: TextStyle(
                                    fontSize: Font.sizes(context)[1])),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              formatCurrency(doc["gia"] * doc.values.first),
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
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
