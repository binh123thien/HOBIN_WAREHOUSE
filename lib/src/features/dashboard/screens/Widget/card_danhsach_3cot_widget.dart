import 'package:flutter/material.dart';

import '../../../../common_widgets/fontSize/font_size.dart';

class CardDanhSach3cotWidget extends StatelessWidget {
  const CardDanhSach3cotWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.nameArrTitle1,
    required this.nameArrTitle2,
    required this.nameArrTitle3,
    required this.hangTonKho,
    required this.height,
  });
  final String title1;
  final String nameArrTitle1;
  final String title2;
  final String nameArrTitle2;
  final String title3;
  final String nameArrTitle3;
  final List<dynamic> hangTonKho;
  final double height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        // color: Colors.yellow,
        width: size.width,
        height: height,
        child: Card(
          color: Colors.white,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        title1,
                        style: TextStyle(
                            fontSize: Font.sizes(context)[0],
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        title2,
                        style: TextStyle(
                            fontSize: Font.sizes(context)[0],
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        title3,
                        style: TextStyle(
                            fontSize: Font.sizes(context)[0],
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: hangTonKho.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  hangTonKho[index][nameArrTitle1],
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  hangTonKho[index][nameArrTitle2].toString(),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  hangTonKho[index][nameArrTitle3].toString(),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
