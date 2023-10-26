import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/chitiet_lichsu_donhang.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../utils/utils.dart';

class CardListDanhSachNo extends StatelessWidget {
  const CardListDanhSachNo({
    super.key,
    required this.docs,
  });

  final List<dynamic> docs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChiTietLichSuDonHang(doc: doc)),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: const Image(image: AssetImage(dangchoIcon)),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(doc["khachhang"],
                                    style: TextStyle(
                                        fontSize: Font.sizes(context)[1])),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "Tổng đơn: ${formatCurrency(doc["tongthanhtoan"])}",
                                      style: const TextStyle(fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  doc["ngaytao"],
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "Nợ: ${formatCurrency(doc["no"])}",
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[0])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
