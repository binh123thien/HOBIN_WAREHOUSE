import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../utils/utils.dart';

class CardLichSuTraNo extends StatefulWidget {
  final List<dynamic> allLichSuTraNo;
  const CardLichSuTraNo({super.key, required this.allLichSuTraNo});

  @override
  State<CardLichSuTraNo> createState() => _CardLichSuTraNoState();
}

class _CardLichSuTraNoState extends State<CardLichSuTraNo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.allLichSuTraNo.length,
              itemBuilder: (context, index) {
                final doc = widget.allLichSuTraNo[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              doc["khachhang"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Font.sizes(context)[1]),
                            ),
                            Text("Nợ cũ: ${formatCurrency(doc["nocu"])}",
                                style: TextStyle(
                                    fontSize: Font.sizes(context)[0])),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 2),
                            Wrap(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${doc["ngaytrano"]}",
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[0],
                                            color: Colors.black54)),
                                    Text(
                                        "Tiền trả: ${formatCurrency(doc["sotientra"])}",
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[0]))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "Còn nợ: ${formatCurrency(doc["conno"])}",
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[0]))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        child: PhanCachWidget.dotLine(context),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
