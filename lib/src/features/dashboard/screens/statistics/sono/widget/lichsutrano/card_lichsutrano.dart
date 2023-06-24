import 'package:flutter/material.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
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

                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: darkColor.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: ImageIcon(
                              AssetImage(refundIcon),
                              color: processColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doc["khachhang"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  doc["ngaytrano"],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Nợ cũ: ${formatCurrency(doc["nocu"])}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: darkColor),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Tiền trả: ${formatCurrency(doc["sotientra"])}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: darkColor),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Còn nợ: ${formatCurrency(doc["conno"])}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: doc["billType"] == "NhapHang"
                                          ? cancel600Color
                                          : darkColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
