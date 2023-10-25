import 'package:flutter/material.dart';

import '../../../../common_widgets/fontSize/font_size.dart';

class CardDanhSach2cotWidget extends StatelessWidget {
  const CardDanhSach2cotWidget({
    super.key,
    required this.nameArr,
    required this.height,
  });
  final double? height;
  final List<dynamic> nameArr;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        // color: Colors.yellow,
        width: size.width,
        height: MediaQuery.of(context).size.height - kToolbarHeight - 225,
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
                      flex: 4,
                      child: Text(
                        "Loại Danh Mục",
                        style: TextStyle(
                            fontSize: Font.sizes(context)[0],
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Tồn kho",
                        style: TextStyle(
                            fontSize: Font.sizes(context)[0],
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: nameArr.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String name = nameArr[index].split(':')[0];
                      final num count =
                          num.tryParse(nameArr[index].split(':')[1]) ?? 0;
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                      fontSize: Font.sizes(context)[0]),
                                  textAlign: TextAlign.right,
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
